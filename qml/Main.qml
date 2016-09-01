import QtQuick 2.5
import QtQuick.Layouts 1.1
import "../components/"

Item {

    // global stuff
    property int    globalWidth
    property string qmlCalendar:       "qrc:/qml/Calendar.qml"
    property string qmlApplications:   "qrc:/qml/Applications.qml"
    property string qmlDisks:          "qrc:/qml/Stats.qml"
    property string qmlPlaces:         "qrc:/qml/Places.qml"
    property string qmlPins:           "qrc:/qml/Pins.qml"
    property string qmlSlideshow:      "qrc:/qml/Slideshow.qml"

    // pretty much everything we need to know about dimensions
    signal loaderPosition(string id, int x, int y, int w, int h)

    // calendar
    property string calendarTime
    property string calendarDate

    // apps
    property string applicationEntry
    property string applicationIcon
    property int    applicationHeight
    signal          applicationLaunch(string application_name)

    // places
    property string placeEntry
    property int    placeHeight
    signal          placeLaunch(string place)

    // disks
    property string diskEntry
    property int    diskHeight

    // pins
    signal exit()
    signal resize(int changed_height)

    // style stuff (default values)
    property color  calendar_background_color:  "#00000000"
    property string calendar_background_image
    property color  calendar_border_color:      "#00000000"
    property int    calendar_border_size:       0
    property string calendar_date_font_family:  "Oxygen-Sans"
    property real   calendar_image_opacity:     0
    property int    calendar_radius:            0
    property color  calendar_text_color:        "#aaffffff"
    property string calendar_time_font_family:  "Oxygen-Sans"

    property color  pins_background_color:      "#00000000"
    property string pins_background_image
    property color  pins_border_color:          "#00000000"
    property int    pins_border_size:           0
    property real   pins_image_opacity:         0
    property int    pins_radius:                0

    property string pin1_background_image
    property color  pin1_border_color:          "#00000000"
    property int    pin1_border_size:           0
    property color  pin1_color1:                "#33ffffff"
    property color  pin1_color2:                "#55ff0000"
    property real   pin1_image_opacity:         0
    property int    pin1_radius:                40

    property string pin2_background_image
    property color  pin2_border_color:          "#00000000"
    property int    pin2_border_size:           0
    property color  pin2_color1:                "#33ffffff"
    property color  pin2_color2:                "#55000000"
    property real   pin2_image_opacity:         0
    property int    pin2_radius:                40

    property string pin3_background_image
    property color  pin3_border_color:          "#00000000"
    property int    pin3_border_size:           0
    property color  pin3_color1:                "#33ffffff"
    property color  pin3_color2:                "#55000000"
    property real   pin3_image_opacity:         0
    property int    pin3_radius:                40

    property color  applications_background_color:  "#00000000"
    property string applications_background_image
    property color  applications_border_color:      "#00000000"
    property int    applications_border_size:       0
    property real   applications_image_opacity:     0
    property int    applications_radius:            0

    property color  places_background_color:  "#00000000"
    property string places_background_image
    property color  places_border_color:      "#00000000"
    property int    places_border_size:       0
    property real   places_image_opacity:     0
    property int    places_radius:            0

    property color  disks_background_color:  "#00000000"
    property string disks_background_image
    property color  disks_border_color:      "#00000000"
    property int    disks_border_size:       0
    property real   disks_image_opacity:     0
    property int    disks_radius:            0

    property color  general_background_color:   "#aa000000"
    property int    general_radius:             0

    Timer { // ugly, but not as ugly as guessing which property will load last (x?,y?,h?,w?)!
        interval:   1
        running:    true
        repeat:     false
        onTriggered: {
            loaderPosition(calendar.source, calendar.x, calendar.y, calendar.width, calendar.height)
            loaderPosition(pins.source, pins.x, pins.y, pins.width, pins.height)
            loaderPosition(applications.source, applications.x, applications.y, applications.width, applications.height)
            loaderPosition(places.source, places.x, places.y, places.width, places.height)
            loaderPosition(disks.source, disks.x, disks.y, disks.width, disks.height)
        }
    }

    anchors.fill:       parent

    Rectangle {
        anchors.fill:   parent
        color:          general_background_color
        radius:         general_radius
    }

    Column {
        spacing:        0
        anchors.fill:   parent

        Row {
            width:      globalWidth
            height:     globalWidth / 4 + globalWidth / 20

            Loader {
                id:     calendar
                source: qmlCalendar
                width:  globalWidth - globalWidth / 10
                height: globalWidth / 4 + globalWidth / 20
            }

            Loader {
                id:     pins
                source: qmlPins
                width:  globalWidth / 10
                height: globalWidth / 4 + globalWidth / 20
            }
        }

        Loader {
            id:         applications
            source:     qmlApplications
            width:      globalWidth
            height:     applicationHeight
        }

        Loader {
            id:         places
            source:     qmlPlaces
            width:      globalWidth
            height:     placeHeight
        }

        Loader {
            id:         disks
            source:     qmlDisks
            width:      globalWidth
            height:     diskHeight
        }
    }
}
