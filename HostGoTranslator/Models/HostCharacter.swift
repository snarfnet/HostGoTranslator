import SwiftUI

enum HostCharacter: String, CaseIterable, Codable, Hashable, Identifiable {
    case oudo
    case oraora
    case chika
    case prince
    case kansai
    case menhera
    case emperor
    case vampire
    case champagne

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .oudo: "王道ホスト"
        case .oraora: "オラオラ系"
        case .chika: "地下メンズ"
        case .prince: "ロマンティック王子"
        case .kansai: "関西ホスト"
        case .menhera: "メンヘラ系"
        case .emperor: "夜王"
        case .vampire: "吸血ホスト"
        case .champagne: "シャンパン王子"
        }
    }

    var shortName: String {
        switch self {
        case .oudo: "王道"
        case .oraora: "オラオラ"
        case .chika: "地下"
        case .prince: "王子"
        case .kansai: "関西"
        case .menhera: "メンヘラ"
        case .emperor: "夜王"
        case .vampire: "吸血"
        case .champagne: "泡王子"
        }
    }

    var sample: String {
        switch self {
        case .oudo: "今日も可愛い更新してるじゃん"
        case .oraora: "俺以外見てんじゃねーよ"
        case .chika: "会えない時間、お前のこと考えてた"
        case .prince: "今日の月、お前見て綺麗になった？"
        case .kansai: "その可愛さ、反則やで"
        case .menhera: "返信ない5分、永遠だった"
        case .emperor: "この夜で一番光ってんの、お前"
        case .vampire: "その可愛さ、少しだけ吸わせて"
        case .champagne: "お前の笑顔でタワー立った"
        }
    }

    var icon: String {
        switch self {
        case .oudo: "sparkles"
        case .oraora: "flame.fill"
        case .chika: "moon.stars.fill"
        case .prince: "crown.fill"
        case .kansai: "bolt.heart.fill"
        case .menhera: "heart.text.square.fill"
        case .emperor: "crown.fill"
        case .vampire: "drop.fill"
        case .champagne: "party.popper.fill"
        }
    }

    var gradient: [Color] {
        switch self {
        case .oudo: [.pink, .yellow]
        case .oraora: [.red, .orange]
        case .chika: [.indigo, .cyan]
        case .prince: [.blue, .mint]
        case .kansai: [.yellow, .green]
        case .menhera: [.purple, .pink]
        case .emperor: [.yellow, .orange]
        case .vampire: [.red, .purple]
        case .champagne: [.yellow, .pink]
        }
    }

    var rarity: HostRarity {
        switch self {
        case .emperor, .vampire, .champagne:
            .ssr
        default:
            .normal
        }
    }

    static var initialUnlocked: [HostCharacter] {
        [.oudo, .oraora, .chika, .prince, .kansai, .menhera]
    }
}

enum HostRarity: String, Codable {
    case normal = "N"
    case rare = "R"
    case ssr = "SSR"

    var displayName: String { rawValue }
}
