module Main exposing (..)

import Browser
import Html exposing (Html, a, main_, div, footer, h1, h2, h3, h4, header, i, img, li, p, section, span, text, ul)
import Html.Attributes as Attr exposing (alt, href, src, target)
import Http
import Json.Decode exposing (Decoder, field, string)


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , view = view
    }

-- MODEL

type alias Model =
    { thunderbirdVersion: String
    }

type Msg
    = GotThunderbirdResp (Result Http.Error String)

init: () -> (Model, Cmd Msg)
init _ =
    ( Model "1.2.0"
    , getThunderbirdVersion
    )


-- UPDATE

githubBaseUrl: String
githubBaseUrl =
    "https://api.github.com/repos"


getThunderbirdVersion: Cmd Msg
getThunderbirdVersion =
    Http.get
        { url = githubBaseUrl ++ "/justverifyit/thunderbird/releases/latest"
        , expect = Http.expectJson GotThunderbirdResp responseDecoder
        }

responseDecoder: Decoder String
responseDecoder =
    field "tag_name" string

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GotThunderbirdResp res ->
            case res of
                Ok tag ->
                    ( { model | thunderbirdVersion = tag }, Cmd.none)
                Err _ ->
                    (model, Cmd.none)


-- VIEW

view: Model -> Html Msg
view model =
    div [ Attr.class "wrapped" ]
        [ viewHeader
        , main_ [] [ viewSectionMain model
                   , viewSectionAdvantages
                   ]
        , viewFooter
        ]


viewHeader: Html Msg
viewHeader =
    header [ Attr.class "header" ]
        [ div [ Attr.class "wrap" ]
            [ div [ Attr.class "flex" ]
                [ a [ Attr.class "logo", href "https://justverify.it/" ]
                    [ img [ alt "Just Verify It", src "img/logo.png" ]
                        []
                    ]
                , div [ Attr.class "action" ]
                    [ a [ Attr.class "btn js_user_agent_link", href "https://github.com/justverifyit", target "_blank" ]
                        [ span [ Attr.class "text" ]
                            [ text "Source Code" ]
                        ]
                    ]
                ]
            ]
        ]

viewSectionAdvantages: Html Msg
viewSectionAdvantages =
    section
        [ Attr.class "section-advantages"
        ]
        [ div
            [ Attr.class "wrap"
            ]
            [ div
                [ Attr.class "flex list-advan"
                ]
                [ div
                    [ Attr.class "item"
                    ]
                    [ div
                        [ Attr.class "img"
                        ]
                        [ img
                            [ Attr.src "img/github.svg"
                            , Attr.alt "github"
                            ]
                            []
                        ]
                    , h3 []
                        [ text "Open-source" ]
                    , p []
                        [ i []
                            [ text "Just Verify It " ]
                        , text "is an open-source project, which means it's developed transparently with the help of the community to create a better product for users." ]
                    ]
                , div
                    [ Attr.class "item"
                    ]
                    [ div
                        [ Attr.class "img"
                        ]
                        [ img
                            [ Attr.src "img/sliders.svg"
                            , Attr.alt "sliders"
                            ]
                            []
                        ]
                    , h3 []
                        [ text "Efficient, fast and scalable" ]
                    , p []
                        [ i []
                            [ text "Just Verify It " ]
                        , text "uses polling to fetch scanning results from VirusTotal in real-time, providing quick and accurate results without delay." ]
                    ]
                , div
                    [ Attr.class "item"
                    ]
                    [ div
                        [ Attr.class "img"
                        ]
                        [ img
                            [ Attr.src "img/virus_total.svg"
                            , Attr.alt "virus-total"
                            ]
                            []
                        ]
                    , h3 []
                        [ text "VirusTotal" ]
                    , p []
                        [ i []
                            [ text "VirusTotal " ]
                        , text "is a trusted and powerful malware scanner that uses advanced techniques to detect and identify all types of malware. With over 50 different antivirus engines, it's a reliable tool for ensuring the safety and security of your digital assets." ]
                    ]
                ]
            ]
        ]

viewSectionMain: Model -> Html Msg
viewSectionMain model =
    section
        [ Attr.class "section-main"
        ]
        [ div
            [ Attr.class "wrap"
            ]
            [ div
                [ Attr.class "block"
                ]
                [ div
                    [ Attr.class "title"
                    ]
                    [ h1 []
                        [ text "Just Verify It - Free and open-source." ]
                    , h2 []
                        [ text "One-click to verify attachments" ]
                    ]
                , div
                    [ Attr.class "action-btn flex"
                    ]
                    [ div
                        [ Attr.class "wrap-btn"
                        ]
                        [ a
                            [ Attr.href "https://addons.thunderbird.net/en-CA/thunderbird/addon/just-verify-it/"
                            , Attr.class "btn js_user_agent_link"
                            , Attr.target "_blank"
                            ]
                            [ span
                                [ Attr.class "text"
                                ]
                                [ text "Thunderbird" ]
                            ]
                        , p
                            [ Attr.class "label"
                            , Attr.id "js_user_agent_version_date"
                            , Attr.attribute "data-text" "%version% - released %date% days ago"
                            ]
                            [ text ("Version " ++ model.thunderbirdVersion) ]
                        ]
                    , div
                        [ Attr.class "wrap-btn"
                        ]
                        [ a
                            [ Attr.href "https://github.com/justverifyit"
                            , Attr.class "btn white"
                            , Attr.target "_blank"
                            ]
                            [ span
                                [ Attr.class "alttext"
                                ]
                                [ text "Source Code" ]
                            ]
                        , p
                            [ Attr.class "label"
                            ]
                            [ text "Github (justverifyit)" ]
                        ]
                    ]
                , div
                    [ Attr.class "description"
                    ]
                    [ p []
                        [ i []
                            [ text "Just Verify It " ]
                        , text "is a Thunderbird add-on that automatically scans all email attachments with VirusTotal for malware, providing real-time scanning results. With Just Verify It, you can stay protected from email-borne threats without the hassle of manual scanning." ]
                    ]
                ]
            ]
        ]


viewFooter: Html Msg
viewFooter =
    footer
        [ Attr.class "footer"
        ]
        [ div
            [ Attr.class "wrap"
            ]
            [ div
                [ Attr.class "flex block-lists"
                ]
                [ div
                    [ Attr.class "item"
                    ]
                    [ a
                        [ Attr.href "https://justverify.it/"
                        , Attr.class "logo"
                        ]
                        [ img
                            [ Attr.src "img/logo.png"
                            , Attr.alt "logo"
                            ]
                            []
                        ]
                    , div
                        [ Attr.class "item"
                        ]
                        [ h4
                            [ Attr.class "title-block"
                            ]
                            [ text "Platforms" ]
                        , ul []
                            [ li []
                                [ a
                                    [ Attr.href "https://addons.thunderbird.net/en-CA/thunderbird/addon/just-verify-it/"
                                    , Attr.target "_blank"
                                    ]
                                    [ text "Thunderbird" ]
                                ]
                            ]
                        ]
                    , div
                        [ Attr.class "item"
                        ]
                        [ h4
                            [ Attr.class "title-block"
                            ]
                            [ text "Resources" ]
                        , ul []
                            [ li []
                                [ a
                                    [ Attr.href "https://github.com/justverifyit"
                                    , Attr.target "_blank"
                                    ]
                                    [ text "Source Code" ]
                                ]
                            ]
                        ]
                    ]
                , div
                    [ Attr.class "copyright"
                    ]
                    [ p []
                        [ text "Just Verify It is developed by ", a
                            [ Attr.href "https://github.com/nicprov"
                            , Attr.target "_blank"
                            ]
                            [ text "Nicolas Provencher under GPL-3.0 License." ]
                        ]
                    ]
                , a
                    [ Attr.href "https://github.com/nicprov"
                    , Attr.target "_blank"
                    ]
                    []
                ]
            , a
                [ Attr.href "https://github.com/nicprov"
                , Attr.target "_blank"
                ]
                []
            ]
        ]