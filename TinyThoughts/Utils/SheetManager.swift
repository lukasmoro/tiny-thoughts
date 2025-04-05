import SwiftUI
import CoreData

// MARK: - Sheet Types
enum SheetType: Identifiable {
    case addCollection
    case quickAddThought
    
    var id: Int {
        switch self {
        case .addCollection: return 0
        case .quickAddThought: return 1
        }
    }
}

// MARK: - Sheet Manager
class SheetManager: ObservableObject {
    @Published var activeSheet: SheetType?
    
    func present(_ sheet: SheetType) {
        activeSheet = sheet
    }
    
    func dismiss() {
        activeSheet = nil
    }
}

// MARK: - Sheet View Builder
struct SheetViewBuilder: View {
    let sheetType: SheetType
    let collectionViewModel: CollectionViewModel
    let viewContext: NSManagedObjectContext
    
    var body: some View {
        switch sheetType {
        case .addCollection:
            AddCollectionView(viewModel: collectionViewModel)
        case .quickAddThought:
            QuickAddThoughtView(collectionViewModel: collectionViewModel, viewContext: viewContext)
        }
    }
} 