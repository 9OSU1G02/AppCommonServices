

import Foundation

class Owl: Hashable, Equatable {

  var name = ""
  var cost: Decimal = 0
  var owned = false

  init(name: String, cost: Decimal) {
    self.name = name
    self.cost = cost
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(cost)
  }

  static func == (lhs: Owl, rhs: Owl) -> Bool {
    return lhs.name == rhs.name && lhs.cost == rhs.cost
  }
}


