#Creating default items

Item.destroy_all

Item.create!([
  {
    name: "Água",
    value: 4
  },
  {
    name: "Comida",
    value: 3
  },
  {
    name: "Medicamentos",
    value: 2
  },
  {
    name: "Munição",
    value: 1
  }
])

p "Created #{Item.count} items"