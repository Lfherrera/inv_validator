# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     InvValidator.Repo.insert!(%InvValidator.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias InvValidator.Sites
alias InvValidator.Users

{:ok, user} = Users.register_user(%{email: "test_user@test.com", password: "Password@1234"})
# Users.change_user_registration()
sites =[
%{site_id: 1, name: "The Miners Club"},
%{site_id: 2, name: "Cimarron Golf Resort"},
%{site_id: 3, name: "Sandcastle Birch Bay"},
%{site_id: 4, name: "WorldMark Phoenix South Mountain Preserve"},
%{site_id: 19, name: "Club Regina, Cancun"},
%{site_id: 20, name: "Kona Reef"},
%{site_id: 21, name: "Polo Towers"},
%{site_id: 22, name: "Park Plaza"},
%{site_id: 23, name: "Teton Club"},
%{site_id: 24, name: "The River Club"},
%{site_id: 25, name: "Franz Klammer Lodge"},
%{site_id: 26, name: "Cypress Pointe Resort"},
%{site_id: 27, name: "Grand Beach Resort"},
%{site_id: 28, name: "Grande Villas Resort"},
%{site_id: 29, name: "Club Regina, Los Cabos"},
%{site_id: 30, name: "Club Regina, Puerto Vallarta"},
%{site_id: 39, name: "Kaanapali Beach Club"},
%{site_id: 40, name: "Lake Tahoe Vacation Resort"},
%{site_id: 43, name: "Sedona Summit"},
%{site_id: 44, name: "The Resorts at Whistler, Whistler Creek"},
%{site_id: 46, name: "The Resorts at Whistler, Woodrun"},
%{site_id: 47, name: "The Resorts at Whistler, Aspens"},
%{site_id: 48, name: "The Resorts at Whistler, Cascade Lodge"},
%{site_id: 50, name: "The Resorts at Whistler, Ironwood"},
%{site_id: 51, name: "The Resorts at Whistler, Lake Placid"},
%{site_id: 52, name: "The Resorts at Whistler, Northstar"},
%{site_id: 53, name: "The Resorts at Whistler, Powders Edge"},
%{site_id: 54, name: "The Resorts at Whistler, Snowbird"},
%{site_id: 55, name: "The Resorts at Whistler, Tyndall Stone"},
%{site_id: 56, name: "The Resorts at Whistler, Village Gate House"},
%{site_id: 57, name: "The Westin Resort and Spa, Whistler"},
%{site_id: 59, name: "The Resorts at Whistler, Town Plaza"},
%{site_id: 60, name: "The Resorts at Whistler, Village Centre"},
%{site_id: 61, name: "The Resorts at Whistler, Valhalla"},
%{site_id: 75, name: "The Modern Honolulu"}
]
|> Enum.map(fn each ->
  Sites.create_site(each)
end)
