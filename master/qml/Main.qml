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
        color:          "#aa000000"
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
