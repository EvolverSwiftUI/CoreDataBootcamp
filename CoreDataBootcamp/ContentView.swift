//
//  ContentView.swift
//  CoreDataBootcamp
//
//  Created by Sivaram Yadav on 11/6/21.
//

// SwiftUI Continued Learning #14:
// How to use Core Data with @FetchRequest
 
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<FruitEntity>

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default
//    )

//    private var items: FetchedResults<Item>
    
    @State var textFieldText: String = ""
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 20) {
                
                TextField("Add Fruit Here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {
                    addItem()
                }, label: {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                .padding(.horizontal)

                
                List {
                    ForEach(items) { item in
                        Text(item.name!)
                            .onTapGesture {
                                updateItem(fruit: item)
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("CoreData Bootcamp")
//            .navigationBarItems(
//                leading:
//                    EditButton(),
//                trailing:
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//            )
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = FruitEntity(context: viewContext)
            newItem.name = textFieldText
            saveItems()
            textFieldText = ""
        }
    }

    private func updateItem(fruit: FruitEntity) {
        withAnimation {
            let currentName = fruit.name ?? ""
            let newName = currentName + "!"
            fruit.name = newName
            saveItems()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else { return }
            let fruitEntity = items[index]
            viewContext.delete(fruitEntity)
            
//            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            saveItems()
        }
    }
    
    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
