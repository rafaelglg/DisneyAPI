//
//  Character.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 6/1/25.
//

import Foundation

struct CharacterModel: Decodable {
    let info: InfoResponse
    let data: [DataResponse]
}

struct InfoResponse: Decodable {
    let count: Int
}

struct DataResponse: Decodable, Identifiable {
    let id: Int
    let films: [String]
    let shortFilms: [String]
    let tvShows: [String]
    let videoGames: [String]
    let parkAttractions: [String]
    let allies: [String]
    let enemies: [String]
    let sourceUrl: String
    let name: String
    let imageUrl: String
    let createdAt: String
    let updatedAt: String
    let url: String
    
    enum CodinKeys: String, CodingKey {
        case id = "_id"
        case films, shortFilms, tvShows, videoGames, parkAttractions, allies, enemies, sourceUrl, name, imageUrl, createdAt, updatedAt, url
    }
    
    static var dataResponseMock: [DataResponse] {
        return [
            DataResponse(
                id: 1,
                films: ["film1","film2"],
                shortFilms: ["ShortFilm1", "ShorFilm2"],
                tvShows: ["tvShows1", "tvShows2"],
                videoGames: ["videoGames1", "videoGames2"],
                parkAttractions: ["parkAttractions1", "parkAttractions2"],
                allies: ["allies1", "allies"],
                enemies: ["enemies1", "enemies2"],
                sourceUrl: "",
                name: "Queen Arianna",
                imageUrl: "https://static.wikia.nocookie.net/disney/images/1/15/Arianna_Tangled.jpg/revision/latest?cb=20160715191802",
                createdAt: "2021-04-12T01:33:34.458Z",
                updatedAt: "2021-04-12T01:33:34.458Z",
                url: ""
            ),
            
            DataResponse(
                id: 2,
                films: ["film1","film2"],
                shortFilms: ["ShortFilm1", "ShorFilm2"],
                tvShows: ["tvShows1", "tvShows2"],
                videoGames: ["videoGames1", "videoGames2"],
                parkAttractions: ["parkAttractions1", "parkAttractions2"],
                allies: ["allies1", "allies"],
                enemies: ["enemies1", "enemies2"],
                sourceUrl: "",
                name: "Queen Arianna",
                imageUrl: "https://static.wikia.nocookie.net/disney/images/1/15/Arianna_Tangled.jpg/revision/latest?cb=20160715191802",
                createdAt: "2021-04-12T01:33:34.458Z",
                updatedAt: "2021-04-12T01:33:34.458Z",
                url: ""
            ),
        ]
    }
    
    static var characterModelMock: [CharacterModel] {
        return [
            CharacterModel(info: InfoResponse.init(count: 1), data: dataResponseMock),
            CharacterModel(info: InfoResponse.init(count: 2), data: dataResponseMock)
        ]
    }
    
}


/*
 
 {
   "info": {
     "totalPages": 149,
     "count": 50,
     "previousPage": "https://api.disneyapi.dev/character?page=3",
     "nextPage": "https://api.disneyapi.dev/character?page=5",
   },
   "data": [
     {
       "_id":308,
       "films":["Tangled","Tangled: Before Ever After"],
       "shortFilms":["Tangled Ever After","Hare Peace"],
       "tvShows":["Once Upon a Time","Tangled: The Series"],
       "videoGames":["Disney Princess Enchanting Storybooks","Hidden Worlds","Disney Crossy Road","Kingdom Hearts III"],
       "parkAttractions":["Celebrate the Magic","Jingle Bell, Jingle BAM!"],
       "allies":[],
       "enemies":[],
       "sourceUrl":"https://disney.fandom.com/wiki/Queen_Arianna",
       "name":"Queen Arianna",
       "imageUrl":"https://static.wikia.nocookie.net/disney/images/1/15/Arianna_Tangled.jpg/revision/latest?cb=20160715191802",
       "createdAt":"2021-04-12T01:33:34.458Z",
       "updatedAt":"2021-04-12T01:33:34.458Z",
       "url":"https://api.disneyapi.dev/characters/308",
       "__v":0
     }
     ...
   ],
 }
 
 */
