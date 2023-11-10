import SwiftUI

struct MTGCardView: View {
    var card: MTGCard
    
    var body: some View {
        VStack {
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
                        .foregroundColor(.red)
                case .empty:
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
            
            Text(card.name)
                .font(.title)
                .padding()
            
            VStack(alignment: .leading) {
                Text("Type: \(card.type_line)")
                Text("Oracle Text: \(card.oracle_text)")
            }
            .padding()
            
            Text("Legalities:")
                .font(.headline)
            
//            HStack(){
//                VStack(){
//                    if let standardLegality = card.legalities?.standard {
//                        legalityTextView(legalityKey: "Standard", legalityValue: standardLegality)
//                    }
//
//                    if let futureLegality = card.legalities?.future {
//                        legalityTextView(legalityKey: "Future", legalityValue: futureLegality)
//                    }
//
//                    if let historicLegality = card.legalities?.historic {
//                        legalityTextView(legalityKey: "Historic", legalityValue: historicLegality)
//                    }
//
//                    if let gladiatorLegality = card.legalities?.gladiator {
//                        legalityTextView(legalityKey: "Gladiator", legalityValue: gladiatorLegality)
//                    }
//
//                    if let pioneerLegality = card.legalities?.pioneer {
//                        legalityTextView(legalityKey: "Pioneer", legalityValue: pioneerLegality)
//                    }
//
//                    if let explorerLegality = card.legalities?.explorer {
//                        legalityTextView(legalityKey: "Explorer", legalityValue: explorerLegality)
//                    }
//
//                    if let modernLegality = card.legalities?.modern {
//                        legalityTextView(legalityKey: "Modern", legalityValue: modernLegality)
//                    }
//
//                    if let legacyLegality = card.legalities?.legacy {
//                        legalityTextView(legalityKey: "Legacy", legalityValue: legacyLegality)
//                    }
//
//                    if let pauperLegality = card.legalities?.pauper {
//                        legalityTextView(legalityKey: "Pauper", legalityValue: pauperLegality)
//                    }
//
//                    if let vintageLegality = card.legalities?.vintage {
//                        legalityTextView(legalityKey: "Vintage", legalityValue: vintageLegality)
//                    }
//
//                    if let pennyLegality = card.legalities?.penny {
//                        legalityTextView(legalityKey: "Penny", legalityValue: pennyLegality)
//                    }
//     
//                    if let commanderLegality = card.legalities?.commander {
//                        legalityTextView(legalityKey: "Commander", legalityValue: commanderLegality)
//                    }
//
//                    if let oathbreakerLegality = card.legalities?.oathbreaker {
//                        legalityTextView(legalityKey: "Oathbreaker", legalityValue: oathbreakerLegality)
//                    }
//
//                    if let brawlLegality = card.legalities?.brawl {
//                        legalityTextView(legalityKey: "Brawl", legalityValue: brawlLegality)
//                    }
//
//                    if let historicBrawlLegality = card.legalities?.historicbrawl {
//                        legalityTextView(legalityKey: "Historic Brawl", legalityValue: historicBrawlLegality)
//                    }
//
//                    if let alchemyLegality = card.legalities?.alchemy {
//                        legalityTextView(legalityKey: "Alchemy", legalityValue: alchemyLegality)
//                    }
//
//                    if let pauperCommanderLegality = card.legalities?.paupercommander {
//                        legalityTextView(legalityKey: "Pauper Commander", legalityValue: pauperCommanderLegality)
//                    }
//
//                    if let duelLegality = card.legalities?.duel {
//                        legalityTextView(legalityKey: "Duel", legalityValue: duelLegality)
//                    }
//
//                    if let oldschoolLegality = card.legalities?.oldschool {
//                        legalityTextView(legalityKey: "Old School", legalityValue: oldschoolLegality)
//                    }
//
//                    if let premodernLegality = card.legalities?.premodern {
//                        legalityTextView(legalityKey: "Premodern", legalityValue: premodernLegality)
//                    }
//
//                    if let predhLegality = card.legalities?.predh {
//                        legalityTextView(legalityKey: "Predh", legalityValue: predhLegality)
//                    }
//                }
//            }
        }
    }
    
    private func legalityTextView(legalityKey: String, legalityValue: String) -> some View {
        HStack {
            if legalityValue.lowercased() == "legal" {
                Text("Legal")
                    .font(.system(size: 12))  // Set a smaller font size
                    .frame(width: 60)  // Set a fixed width
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            } else {
                Text("Not Legal")
                    .font(.system(size: 12))  // Set a smaller font size
                    .frame(width: 60)  // Set a fixed width
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
            Text(legalityKey)
                .font(.system(size: 12))
        }
    }
}



struct ContentView: View {
    @State private var mtgCards: [MTGCard] = []
    @State private var searchText: String = ""

    var filteredCards: [MTGCard] {
        if searchText.isEmpty {
            return mtgCards
        } else {
            return mtgCards.filter { card in
                return card.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)

                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 5), spacing: 16) {
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
            .navigationBarTitle("MTG Cards")
        }
    }

    // Fungsi untuk memuat data dari file JSON
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
                        .frame(height: 100) // Adjust the height as needed
                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.red)
                        .frame(height: 100) // Adjust the height as needed
                case .empty:
                    ProgressView()
                        .frame(height: 100) // Adjust the height as needed
                @unknown default:
                    ProgressView()
                        .frame(height: 100) // Adjust the height as needed
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
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding([.leading, .trailing], 0)

            Button(action: {
                self.text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 8)
            .opacity(text.isEmpty ? 0 : 1)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
