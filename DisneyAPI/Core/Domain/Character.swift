//
//  Character.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 6/1/25.
//

import Foundation

struct CharacterModel: Codable, Sendable {
    let info: InfoResponse
    let data: [CharacterDataResponse]
    
    static var emptyMock: CharacterModel {
        CharacterModel(info: InfoResponse(count: 0), data: CharacterDataResponse.emptyMock)
    }
    
    static var mock: CharacterModel {
        mocks[0]
    }
    
    static var mocks: [CharacterModel] {
        return [
            CharacterModel(
                info: InfoResponse(count: 1), data: CharacterDataResponse.dataResponseMock),
            CharacterModel(
                info: InfoResponse(count: 2), data: CharacterDataResponse.dataResponseMock),
            CharacterModel(
                info: InfoResponse(count: 3), data: CharacterDataResponse.dataResponseMock),
            CharacterModel(
                info: InfoResponse(count: 4), data: CharacterDataResponse.dataResponseMock),
            CharacterModel(
                info: InfoResponse(count: 5), data: CharacterDataResponse.dataResponseMock),
            CharacterModel(
                info: InfoResponse(count: 6), data: CharacterDataResponse.dataResponseMock)
        ]
    }
}

struct InfoResponse: Codable {
    let count: Int
}

struct CharacterDataResponse: Codable, Identifiable, Sendable, Hashable {
    let id: Int
    let films: [String]?
    let shortFilms: [String]?
    let tvShows: [String]?
    let videoGames: [String]?
    let parkAttractions: [String]?
    let allies: [String]?
    let enemies: [String]?
    let sourceUrl: String?
    let name: String?
    let imageUrl: String?
    let createdAt: String?
    let updatedAt: String?
    let url: String?
    
    init(
        id: Int,
        films: [String]? = nil,
        shortFilms: [String]? = nil,
        tvShows: [String]? = nil,
        videoGames: [String]? = nil,
        parkAttractions: [String]? = nil,
        allies: [String]? = nil,
        enemies: [String]? = nil,
        sourceUrl: String? = nil,
        name: String? = nil,
        imageUrl: String? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        url: String? = nil
    ) {
        self.id = id
        self.films = films
        self.shortFilms = shortFilms
        self.tvShows = tvShows
        self.videoGames = videoGames
        self.parkAttractions = parkAttractions
        self.allies = allies
        self.enemies = enemies
        self.sourceUrl = sourceUrl
        self.name = name
        self.imageUrl = imageUrl
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id" // Mapea "_id" del JSON a "id"
        case films, shortFilms, tvShows, videoGames, parkAttractions, allies,
             enemies, sourceUrl, name, imageUrl, createdAt, updatedAt, url
    }
    
    static var emptyMock: [CharacterDataResponse] {
        return [
            CharacterDataResponse(id: 0)
        ]
    }
    
    static var mock: CharacterDataResponse {
        .dataResponseMock[0]
    }

    static var dataResponseMock: [CharacterDataResponse] {
        return [
            CharacterDataResponse(
                id: 1,
                films: ["film1", "film2"],
                shortFilms: ["ShortFilm1", "ShorFilm2"],
                tvShows: ["tvShows1", "tvShows2"],
                videoGames: ["videoGames1", "videoGames2"],
                parkAttractions: ["parkAttractions1", "parkAttractions2"],
                allies: ["allies1", "allies"],
                enemies: ["enemies1", "enemies2"],
                sourceUrl: "",
                name: "Queen Arianna",
                imageUrl:
                    "https://static.wikia.nocookie.net/disney/images/1/15/Arianna_Tangled.jpg/revision/latest?cb=20160715191802",
                createdAt: "2021-04-12T01:33:34.458Z",
                updatedAt: "2021-04-12T01:33:34.458Z",
                url: ""
            ),

            CharacterDataResponse(
                id: 2,
                films: ["film1", "film2"],
                shortFilms: ["ShortFilm1", "ShorFilm2"],
                tvShows: ["tvShows1", "tvShows2"],
                videoGames: ["videoGames1", "videoGames2"],
                parkAttractions: ["parkAttractions1", "parkAttractions2"],
                allies: ["allies1", "allies"],
                enemies: ["enemies1", "enemies2"],
                sourceUrl: "",
                name: "Queen Arianna",
                imageUrl:
                    "https://static.wikia.nocookie.net/disney/images/1/15/Arianna_Tangled.jpg/revision/latest?cb=20160715191802",
                createdAt: "2021-04-12T01:33:34.458Z",
                updatedAt: "2021-04-12T01:33:34.458Z",
                url: ""
            ),
            CharacterDataResponse(
                id: 3,
                films: ["film1", "film2"],
                shortFilms: ["ShortFilm1", "ShorFilm2"],
                tvShows: ["tvShows1", "tvShows2"],
                videoGames: ["videoGames1", "videoGames2"],
                parkAttractions: ["parkAttractions1", "parkAttractions2"],
                allies: ["allies1", "allies"],
                enemies: ["enemies1", "enemies2"],
                sourceUrl: "",
                name: "Queen Arianna",
                imageUrl:
                    "https://static.wikia.nocookie.net/disney/images/1/15/Arianna_Tangled.jpg/revision/latest?cb=20160715191802",
                createdAt: "2021-04-12T01:33:34.458Z",
                updatedAt: "2021-04-12T01:33:34.458Z",
                url: ""
            ),
            CharacterDataResponse(
                id: 4,
                films: ["film1", "film2"],
                shortFilms: ["ShortFilm1", "ShorFilm2"],
                tvShows: ["tvShows1", "tvShows2"],
                videoGames: ["videoGames1", "videoGames2"],
                parkAttractions: ["parkAttractions1", "parkAttractions2"],
                allies: ["allies1", "allies"],
                enemies: ["enemies1", "enemies2"],
                sourceUrl: "",
                name: "Queen Arianna",
                imageUrl:
                    "https://static.wikia.nocookie.net/disney/images/1/15/Arianna_Tangled.jpg/revision/latest?cb=20160715191802",
                createdAt: "2021-04-12T01:33:34.458Z",
                updatedAt: "2021-04-12T01:33:34.458Z",
                url: ""
            ),
            CharacterDataResponse(
                id: 5,
                films: ["film1", "film2"],
                shortFilms: ["ShortFilm1", "ShorFilm2"],
                tvShows: ["tvShows1", "tvShows2"],
                videoGames: ["videoGames1", "videoGames2"],
                parkAttractions: ["parkAttractions1", "parkAttractions2"],
                allies: ["allies1", "allies"],
                enemies: ["enemies1", "enemies2"],
                sourceUrl: "",
                name: "Queen Arianna",
                imageUrl:
                    "https://static.wikia.nocookie.net/disney/images/1/15/Arianna_Tangled.jpg/revision/latest?cb=20160715191802",
                createdAt: "2021-04-12T01:33:34.458Z",
                updatedAt: "2021-04-12T01:33:34.458Z",
                url: ""
            )
        ]
    }
}
