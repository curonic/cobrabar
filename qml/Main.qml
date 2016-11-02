import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import "../components/"

Item {

    clip: true
    // global stuff
    property string qmlDate:       "qrc:/qml/Date.qml"
    property string qmlTime:       "qrc:/qml/Time.qml"
    property string qmlApplications:   "qrc:/qml/Applications.qml"
    property string qmlPlaces:         "qrc:/qml/Places.qml"
    property string qmlPins:           "qrc:/qml/Pins.qml"
    property string qmlSlideshow:      "qrc:/qml/Slideshow.qml"

    signal tooltipShow(string tooltip, int tooltip_width, int tooltip_height, string tooltip_color, string tooltip_background_color, int tooltip_border_radius)
    signal tooltipClose()
    signal globalWidth(int width)
    signal globalExtended(bool state)

    // calendar
    property string calendarTime
    property string calendarDate
    property int    timeHeight
    property int    dateHeight

    // apps
    property string applicationEntry
    property string applicationIcon
    property int    applicationHeight
    signal          applicationLaunch(string application_name)

    // places
    property string placeEntry
    property string placeIcon
    property int    placeHeight
    signal          placeLaunch(string place)

    // pins
    property int    pinsHeight
    signal exit()
    signal resize(int changed_height)

    // style stuff (default values)
    property color  calendar_background_color
    property string calendar_background_image
    property color  calendar_border_color
    property int    calendar_border_width
    property real   calendar_image_opacity
    property int    calendar_border_radius

    property color  date_color
    property string date_font_family

    property color  time_color
    property string time_font_family

    property color  pins_background_color
    property string pins_background_image
    property color  pins_border_color
    property int    pins_border_width
    property real   pins_image_opacity
    property int    pins_border_radius

    property string pin1_background_image
    property int    pin1_border_width
    property color  pin1_background_gradient_top
    property color  pin1_background_gradient_bottom
    property color  pin1_border_gradient_top
    property color  pin1_border_gradient_bottom
    property real   pin1_image_opacity
    property int    pin1_border_radius
    property color  pin1_inner_border_color
    property int    pin1_inner_border_width
    property color  pin1_outer_border_color
    property int    pin1_outer_border_width

    property string pin2_background_image
    property int    pin2_border_width
    property color  pin2_background_gradient_top
    property color  pin2_background_gradient_bottom
    property color  pin2_border_gradient_top
    property color  pin2_border_gradient_bottom
    property real   pin2_image_opacity
    property int    pin2_border_radius
    property color  pin2_inner_border_color
    property int    pin2_inner_border_width
    property color  pin2_outer_border_color
    property int    pin2_outer_border_width

    property string pin3_background_image
    property int    pin3_border_width
    property color  pin3_background_gradient_top
    property color  pin3_background_gradient_bottom
    property color  pin3_border_gradient_top
    property color  pin3_border_gradient_bottom
    property real   pin3_image_opacity
    property int    pin3_border_radius
    property color  pin3_inner_border_color
    property int    pin3_inner_border_width
    property color  pin3_outer_border_color
    property int    pin3_outer_border_width

    property color  applications_background_color
    property string applications_background_image
    property color  applications_border_color
    property int    applications_border_width
    property real   applications_image_opacity
    property int    applications_border_radius

    property color  places_background_color
    property string places_background_image
    property color  places_border_color
    property int    places_border_width
    property real   places_image_opacity
    property int    places_border_radius

    property string general_alignment
    property color  general_background_color
    property color  general_border_color
    property string general_background_image
    property int    general_blur_radius
    property int    general_border_radius
    property int    general_border_width
    property real   general_image_opacity
    property int    general_width
    property bool   general_extended_height

    property color  applicationbutton_background_gradient_bottom
    property color  applicationbutton_background_gradient_top
    property color  applicationbutton_border_color
    property int    applicationbutton_border_radius
    property int    applicationbutton_border_width
    property color  applicationbutton_color
    property string applicationbutton_font_family
    property bool   applicationbutton_icon_grayscale
    property string applicationbutton_text_align

    property color  applicationbutton_focus_background_gradient_bottom
    property color  applicationbutton_focus_background_gradient_top
    property color  applicationbutton_focus_border_color
    property int    applicationbutton_focus_border_radius
    property int    applicationbutton_focus_border_width
    property color  applicationbutton_focus_color
    property string applicationbutton_focus_font_family
    property bool   applicationbutton_focus_icon_grayscale
    property string applicationbutton_focus_text_align

    property color  applicationbutton_hover_background_gradient_bottom
    property color  applicationbutton_hover_background_gradient_top
    property color  applicationbutton_hover_border_color
    property int    applicationbutton_hover_border_radius
    property int    applicationbutton_hover_border_width
    property color  applicationbutton_hover_color
    property string applicationbutton_hover_font_family
    property bool   applicationbutton_hover_icon_grayscale
    property string applicationbutton_hover_text_align

    property color  placebutton_background_gradient_bottom
    property color  placebutton_background_gradient_top
    property color  placebutton_border_color
    property int    placebutton_border_radius
    property int    placebutton_border_width
    property color  placebutton_color
    property string placebutton_font_family
    property bool   placebutton_icon_grayscale
    property string placebutton_text_align

    property color  placebutton_focus_background_gradient_bottom
    property color  placebutton_focus_background_gradient_top
    property color  placebutton_focus_border_color
    property int    placebutton_focus_border_radius
    property int    placebutton_focus_border_width
    property color  placebutton_focus_color
    property string placebutton_focus_font_family
    property bool   placebutton_focus_icon_grayscale
    property string placebutton_focus_text_align

    property color  placebutton_hover_background_gradient_bottom
    property color  placebutton_hover_background_gradient_top
    property color  placebutton_hover_border_color
    property int    placebutton_hover_border_radius
    property int    placebutton_hover_border_width
    property color  placebutton_hover_color
    property string placebutton_hover_font_family
    property bool   placebutton_hover_icon_grayscale
    property string placebutton_hover_text_align

    property string tooltip_color
    property string tooltip_background_color
    property int    tooltip_border_radius

    anchors.fill:     parent

    Rectangle {
        anchors.fill: parent
        color:        general_background_color
        radius:       general_border_radius
        border.width: general_border_width
        border.color: general_border_color
    }

    Image {
        id:                  img
        source:              general_background_image
        anchors.centerIn:    parent
        width:               parent.width  - general_border_width * 2
        height:              parent.height - general_border_width * 2
        fillMode:            Image.Pad
        horizontalAlignment: Image.AlignLeft
        verticalAlignment:   Image.AlignTop
        layer.enabled:       true
        layer.effect:
            OpacityMask { maskSource:
                Item {
                width:      img.width
                height:     img.height

                Rectangle {
                    anchors.centerIn: parent
                    width:            parent.width
                    height:           parent.height
                    radius:           general_border_radius
                    opacity:          general_image_opacity
                }
            }
        }
    }

    Column {
        spacing:           0
        anchors.fill:      parent
        anchors.top:       parent.top
        anchors.topMargin: general_border_width

        Loader {
            id:                       pins
            source:                   qmlPins
            width:                    general_width - general_border_width * 2
            anchors.horizontalCenter: parent.horizontalCenter
            height:                   pinsHeight
        }

        Loader {
            id:     time
            source: qmlTime
            width:  general_width - general_border_width * 2
            anchors.horizontalCenter: parent.horizontalCenter
            height: timeHeight
        }

        Loader {
            id:     date
            source: qmlDate
            width:  general_width - general_border_width * 2
            anchors.horizontalCenter: parent.horizontalCenter
            height: dateHeight;
        }

        Loader {
            id:     applications
            source: qmlApplications
            width:  general_width - general_border_width * 2
            anchors.horizontalCenter: parent.horizontalCenter
            height: applicationHeight
        }

        Loader {
            id:     places
            source: qmlPlaces
            width:  general_width - general_border_width * 2
            anchors.horizontalCenter: parent.horizontalCenter
            height: placeHeight
        }
    }
}
