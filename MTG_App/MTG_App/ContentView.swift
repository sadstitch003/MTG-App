import SwiftUI

struct MTGCardView: View {
    @State private var isShowingFullCard = false
    var card: MTGCard
    var body: some View {
        ScrollView(){
            VStack {
                Button(action: {
                    isShowingFullCard.toggle()
                }) {
                    AsyncImage(url: URL(string: card.image_uris?.art_crop ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                        case .empty:
                            ProgressView()
                        @unknown default:
                            ProgressView()
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle()) // Remove the button's default style
                
                // Full Card View
                .fullScreenCover(isPresented: $isShowingFullCard) {
                    FullCardView(isPresented: $isShowingFullCard, card: card)
                }
            }
            .padding(.top, 100)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(card.name)
                        .font(.system(size: 24))
                        .bold()
                    
                    Spacer()
                    parseManaCost(manaCost: card.mana_cost)
                }
                
                Text(card.type_line)
                    .font(.system(size: 16))
                    .bold()
                
                VStack(alignment: .leading) {
                    Text(card.oracle_text)
                        .font(.system(size: 12))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
                Text("Legalities:")
                    .font(.headline)
                
                HStack(alignment: .top){
                    VStack(alignment: .leading){
                        if let standardLegality = card.legalities?.standard {
                            legalityTextView(legalityKey: "Standard", legalityValue: standardLegality)
                        }
                        
                        if let futureLegality = card.legalities?.future {
                            legalityTextView(legalityKey: "Future", legalityValue: futureLegality)
                        }
                        
                        if let historicLegality = card.legalities?.historic {
                            legalityTextView(legalityKey: "Historic", legalityValue: historicLegality)
                        }
                        
                        if let gladiatorLegality = card.legalities?.gladiator {
                            legalityTextView(legalityKey: "Gladiator", legalityValue: gladiatorLegality)
                        }
                        
                        if let pioneerLegality = card.legalities?.pioneer {
                            legalityTextView(legalityKey: "Pioneer", legalityValue: pioneerLegality)
                        }
                        
                        if let explorerLegality = card.legalities?.explorer {
                            legalityTextView(legalityKey: "Explorer", legalityValue: explorerLegality)
                        }
                        
                        if let modernLegality = card.legalities?.modern {
                            legalityTextView(legalityKey: "Modern", legalityValue: modernLegality)
                        }
                        
                        if let legacyLegality = card.legalities?.legacy {
                            legalityTextView(legalityKey: "Legacy", legalityValue: legacyLegality)
                        }
                        
                        if let pauperLegality = card.legalities?.pauper {
                            legalityTextView(legalityKey: "Pauper", legalityValue: pauperLegality)
                        }
                        
                        if let vintageLegality = card.legalities?.vintage {
                            legalityTextView(legalityKey: "Vintage", legalityValue: vintageLegality)
                        }
                        
                        if let pennyLegality = card.legalities?.penny {
                            legalityTextView(legalityKey: "Penny", legalityValue: pennyLegality)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading){
                        if let commanderLegality = card.legalities?.commander {
                            legalityTextView(legalityKey: "Commander", legalityValue: commanderLegality)
                        }
                        
                        if let oathbreakerLegality = card.legalities?.oathbreaker {
                            legalityTextView(legalityKey: "Oathbreaker", legalityValue: oathbreakerLegality)
                        }
                        
                        if let brawlLegality = card.legalities?.brawl {
                            legalityTextView(legalityKey: "Brawl", legalityValue: brawlLegality)
                        }
                        
                        if let historicBrawlLegality = card.legalities?.historicbrawl {
                            legalityTextView(legalityKey: "Historic Brawl", legalityValue: historicBrawlLegality)
                        }
                        
                        if let alchemyLegality = card.legalities?.alchemy {
                            legalityTextView(legalityKey: "Alchemy", legalityValue: alchemyLegality)
                        }
                        
                        if let pauperCommanderLegality = card.legalities?.paupercommander {
                            legalityTextView(legalityKey: "Pauper Commander", legalityValue: pauperCommanderLegality)
                        }
                        
                        if let duelLegality = card.legalities?.duel {
                            legalityTextView(legalityKey: "Duel", legalityValue: duelLegality)
                        }
                        
                        if let oldschoolLegality = card.legalities?.oldschool {
                            legalityTextView(legalityKey: "Old School", legalityValue: oldschoolLegality)
                        }
                        
                        if let premodernLegality = card.legalities?.premodern {
                            legalityTextView(legalityKey: "Premodern", legalityValue: premodernLegality)
                        }
                        
                        if let predhLegality = card.legalities?.predh {
                            legalityTextView(legalityKey: "Predh", legalityValue: predhLegality)
                        }
                    }
                }
            }.padding([.leading, .trailing], 14)
        }.ignoresSafeArea()
    }
    
    private func legalityTextView(legalityKey: String, legalityValue: String) -> some View {
        HStack {
            if legalityValue.lowercased() == "legal" {
                Text("Legal")
                    .font(.system(size: 11))
                    .frame(width: 60)
                    .padding(4)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(4)
            } else {
                Text("Not Legal")
                    .font(.system(size: 11))
                    .frame(width: 60)
                    .padding(4)
                    .background(Color.gray)
                    .foregroundColor(.black)
                    .cornerRadius(4)
            }
            Text(legalityKey)
                .font(.system(size: 12))
        }
    }
    
    private func parseManaCost(manaCost: String) -> some View {
        let manaSymbols = manaCost.components(separatedBy: CharacterSet(charactersIn: "{}"))
            .filter { !$0.isEmpty }
        
        return HStack(spacing: 5) {
            ForEach(manaSymbols, id: \.self) { symbol in
                Image(symbol)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.black)
            }
        }
    }
}

struct FullCardView: View {
    @Binding var isPresented: Bool
    var card: MTGCard
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            AsyncImage(url: URL(string: card.image_uris?.large ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                case .empty:
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
            .aspectRatio(contentMode: .fit)
        }
        .onTapGesture {
            isPresented = false
        }
    }
}


struct ContentView: View {
    @State private var mtgCards: [MTGCard] = []
    @State private var searchText: String = ""
    @State private var isAscendingOrder: Bool = true // To toggle between ascending and descending order

    var sortedCards: [MTGCard] {
        // Sorting the cards based on card name in ascending or descending order
        if isAscendingOrder {
            return mtgCards.sorted { $0.name < $1.name }
        } else {
            return mtgCards.sorted { $0.name > $1.name }
        }
    }

    var filteredCards: [MTGCard] {
        // Filtering logic remains the same
        if searchText.isEmpty {
            return sortedCards
        } else {
            return sortedCards.filter { card in
                return card.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    SearchBar(text: $searchText)
                    
                    Button(action: {
                        isAscendingOrder.toggle()
                    }) {
                        Image(systemName: isAscendingOrder ? "arrow.up" : "arrow.down")
                            .padding(0)
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 20)
                }

                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 8) {
                        ForEach(filteredCards) { card in
                            NavigationLink(destination: MTGCardView(card: card)) {
                                MTGCardRow(card: card)
                            }
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                // Load data dari file JSON
                if let data = loadJSON() {
                    do {
                        let decoder = JSONDecoder()
                        let cards = try decoder.decode(MTGCardList.self, from: data)
                        mtgCards = cards.data
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
            .navigationBarTitle("Magic The Gathering")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.black)
        }
    }

    func loadJSON() -> Data? {
        if let path = Bundle.main.path(forResource: "WOT-Scryfall", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                print("Error loading JSON: \(error)")
            }
        }
        return nil
    }
}

struct MTGCardRow: View {
    var card: MTGCard
    var body: some View {
        VStack {
            // Tampilkan gambar kartu
            AsyncImage(url: URL(string: card.image_uris?.large ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120) // Adjust the height as needed
                        .cornerRadius(5)
                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.red)
                        .frame(height: 120) // Adjust the height as needed
                case .empty:
                    ProgressView()
                        .frame(height: 120) // Adjust the height as needed
                @unknown default:
                    ProgressView()
                        .frame(height: 120) // Adjust the height as needed
                }
                
                VStack(){
                    Text(card.name)
                        .font(.caption)
                        .padding(.top, 4)
                }
                
                Spacer()
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        ZStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding([.leading, .trailing], 0)
                .foregroundColor(.black)

            HStack(){
                Spacer()
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
                .opacity(text.isEmpty ? 0 : 1)
            }
        }
        .padding(.leading, 14)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
