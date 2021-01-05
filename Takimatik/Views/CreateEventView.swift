//
//  CreateEvent.swift
//  Takimatik
//
//  Created by Metin Öztürk on 25.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI
import CoreLocation
import Contacts

struct CreateEventView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @ObservedObject var createEventViewModel: CreateEventViewModel
    
    @ObservedObject var contactsManager = ContactsManager()
    
    @State private var rEventName : String = ""
    
    @State private var selectedStartDate = Date()
    @State private var selectedEndDate = Date()

    @State private var selectedEventIdx = 1
    
    @State var isShowingImagePicker : Bool = false
    @State var isShowingContactPickerView : Bool = false
    
    @State var isShowingMapView : Bool = false
    @State var rEventLocation : SelectedLocation?
        
    @State var isLoading = false
    
    @State var rContacts = [Invitee]()
    
    @State var isFieldMissing : Bool = false
    @State var fieldsMissing = [String]()
    
    @State var rImage : Image? = nil
    @State var retrievedImage : UIImage? = nil
    
    @State var tlAccount: String = ""
    @State var grGoldAccount: String = ""
    @State var quarterGoldAccount: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            BaseView(isLoading: self.isLoading) {
                VStack {
                    Form {
                        Group {
                            Section(header: Text("Etkinlik Bilgileri")) {
                                
                                TextField("Etkinlik Adı", text: self.$rEventName)
                                    
                                
                                Picker(selection: self.$selectedEventIdx, label: Text("Etkinlik Türü:")) {
                                    Text("Düğün").tag(1).font(Font.system(size: 17))
                                    Text("Baby Shower").tag(2).font(Font.system(size: 17))
                                    Text("Doğum Günü").tag(3).font(Font.system(size: 17))
                                }
                                
                                
                                DatePicker("Etkinlik Başlangıç Tarihi:", selection: self.$selectedStartDate, displayedComponents: [.date, .hourAndMinute])
                                    .environment(\.locale, Locale.init(identifier: "tr"))
                             
                                DatePicker("Etkinlik Bitiş Tarihi:", selection: self.$selectedEndDate, displayedComponents: [.date, .hourAndMinute])
                                    .environment(\.locale, Locale.init(identifier: "tr"))
                                
                            }
                            
                            Section(header: Text("Etkinlik Davetlileri")) {
                                
                                    if self.rContacts.count > 0 {
                                        ScrollView(.vertical, showsIndicators: false) {
                                            List(self.rContacts) { (invitee) in
                                                InviteeRowView(invitee: invitee, isSelected: false)
                                            }
                                            .frame(height: self.rContacts.count > 2 ? 130 : CGFloat(40 * self.rContacts.count), alignment: .leading)
                                        }
                                    }
                                    
                                    Button(action: {
                                        self.isShowingContactPickerView.toggle()
                                    }) {
                                        Text("Rehberden Ekle")
                                             .foregroundColor(Util.shared.buttonColor)
                                    }.sheet(isPresented: self.$isShowingContactPickerView, onDismiss: {
                                        self.rContacts = self.createEventViewModel.selectedContacts
                                    }) {
                                        ContactPickerView(createEventViewModel: self.createEventViewModel, isShowing: self.$isShowingContactPickerView, initialContacts: self.contactsManager.rContacts)
                                    }.buttonStyle(TMButtonStyle())
                                    
                            }
                            
                            Section(header: Text("Etkinlik Görseli")) {
                                if self.rImage != nil {
                                    self.rImage!
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200, alignment: .center)
                                        .clipped()
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    self.hideKeyboard()
                                    self.isShowingImagePicker.toggle()
                                }) {
                                    Text("Galeriye Git")
                                }.sheet(isPresented: self.$isShowingImagePicker, onDismiss: {
                                    self.createEventViewModel.selectedImage = self.retrievedImage
                                    self.rImage = self.createEventViewModel.selectedImage != nil ? Image(uiImage: self.createEventViewModel.selectedImage!) : nil
                                }) {
                                    ImagePickerView(isBeingPresented: self.$isShowingImagePicker, retrievedImage: self.$retrievedImage)
                                }.buttonStyle(TMButtonStyle())

                            }
                            
                            
                            Section(header: Text("Etkinlik Konumu")) {
                                if self.isShowingMapView {
                                    MapView(selectedLocation: self.$rEventLocation)
                                        .frame(width: geometry.size.width - 32, height: geometry.size.width - 32, alignment: .center)
                                        .cornerRadius(10)
                                } else if self.rEventLocation != nil {
                                    Text("\(self.rEventLocation?.address ?? "")")
                                }
                                
                                Button(action: {
                                    self.isShowingMapView.toggle()
                                }) {
                                    Text(self.isShowingMapView ? "Konum Onayla" : self.rEventLocation != nil ? "Konum Değiştir" : "Konum Seç")
                                }
                                .buttonStyle(TMButtonStyle())
                                
                            }
                            
                            Section(header: Text("Etkinlik Hesapları")) {
                                TextField("TL Hesabı", text: self.$tlAccount)
                                TextField("Gram Altın Hesabı", text: self.$grGoldAccount)
                                TextField("Çeyrek Altın Hesabı", text: self.$quarterGoldAccount)

                            }
                            
                            
                            Section {
                                HStack {
                                    Spacer()
                                    
                                    Button(action: {
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.locale = Locale(identifier: "tr_TR")
                                        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                                        
                                        if self.checkFields() {
                                            self.isLoading = true
                                            
                                            let dispatchDownloadGroup = DispatchGroup()
                                            
                                            let (fileUrl,fileName,_,_) = Util.shared.writeImageToFile(img: self.createEventViewModel.selectedImage!)
                                            
                                            self.rContacts.append(Invitee(id: self.userViewModel.user.id, name: "Metin ÖZ", phoneNumber: self.userViewModel.user.phoneNumber)) // add founder to invitees
                                            
                                            if let fileUrl = fileUrl , let fileName = fileName {
                                                dispatchDownloadGroup.enter()
                                                self.createEventViewModel.event = Event(title: self.rEventName,
                                                      eventType: EventType(rawValue: self.selectedEventIdx) ?? EventType.Wedding,
                                                      participationStatus: .Founded,
                                                      latitude: String(self.rEventLocation?.coordinate.latitude ?? 0),
                                                      longitude: String(self.rEventLocation?.coordinate.longitude ?? 0),
                                                      startDate: dateFormatter.string(from: self.selectedStartDate),
                                                      endDate: dateFormatter.string(from: self.selectedEndDate),
                                                      image: fileName.replacingOccurrences(of: ".jpg", with: "").trimmingCharacters(in: .whitespacesAndNewlines),
                                                      founderPhoneNumber: self.userViewModel.user.phoneNumber,
                                                      invitees: self.rContacts)
                                                

                                                Util.shared.uploadImageAws(fileUrl: fileUrl, fileName: fileName){ uploadResult in
                                                    dispatchDownloadGroup.leave()
                                                    if uploadResult {
                                                        print("Image uploaded successfully", fileName)
                                                    }
                                                }
                                            }
    
                                            dispatchDownloadGroup.enter()
                                            self.createEventViewModel.createEvent { (isEventCreated) in
                                                dispatchDownloadGroup.leave()
                                                if isEventCreated {
                                                    print("Event created successfully")
                                                }
                                            }
                                            
                                            dispatchDownloadGroup.notify(queue: .main) {
                                                self.isLoading = false
                                                self.presentationMode.wrappedValue.dismiss()
                                            }
                                        } else {
                                            self.isFieldMissing = true
                                        }
                                        

                                        
                                    }) {
                                        Text("Etkinlik Yarat")
                                        
                                    }.alert(isPresented: self.$isFieldMissing) { () -> Alert in
                                        var alertMessage = "Lütfen aşağıdaki bilgileri doğru şekilde sağladığınızdan emin olun:\n"
                                        
                                        self.fieldsMissing.forEach {
                                            alertMessage.append("•\($0)\n")
                                        }
                                        
                                        return Alert(title: Text("Uyarı"), message: Text(alertMessage))
                                    }
                                    
                                }.buttonStyle(TMButtonStyle())
                            }
                            
                        }
                    }
                }
                
            }.navigationBarTitle("Etkinlik Yarat")
                .onAppear {
                    self.createEventViewModel.clear()
                    self.contactsManager.fetchContacts()
            }

        }
    }
    
    
    private func checkFields() -> Bool {
        fieldsMissing.removeAll()

        var checkResult = true
            
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "tr_TR")
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        let currentDateAsSeconds = Date().timeIntervalSince1970
        let rStartDateAsSeconds  = Double(selectedStartDate.timeIntervalSince1970)
        let rEndDateAsSeconds  = Double(selectedEndDate.timeIntervalSince1970)
        
        if self.rEventName.isEmpty {
            fieldsMissing.append("Başlık")
            checkResult = false
        }
        if (rEventLocation?.coordinate.latitude == 0 && rEventLocation?.coordinate.longitude == 0) || rEventLocation?.coordinate.latitude == nil || rEventLocation?.coordinate.longitude == nil {
            fieldsMissing.append("Konum")
            checkResult = false
        }
        
        if rStartDateAsSeconds < currentDateAsSeconds - 900000 || rEndDateAsSeconds < currentDateAsSeconds - 900000 || rEndDateAsSeconds < rStartDateAsSeconds {
            fieldsMissing.append("Tarih")
            checkResult = false
        }
        
        if self.rContacts.isEmpty {
            fieldsMissing.append("Davetliler")
            checkResult = false
        }
        
        if createEventViewModel.selectedImage == nil {
            fieldsMissing.append("Etkinlik Görseli")
            checkResult = false
        }
        
        return checkResult
    }
    
}



//struct CreateEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateEventView()
//    }
//}
//



