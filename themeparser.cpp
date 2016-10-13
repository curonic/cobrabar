/****************************************************************************
 *                                                                          *
 *                    Copyright (C) 2016  <name of author>                  *
 *                                                                          *
 *   This program is free software: you can redistribute it and/or modify   *
 *   it under the terms of the GNU General Public License as published by   *
 *   the  Free Software Foundation,  either version 3 of the License,  or   *
 *   (at your option) any later version.                                    *
 *                                                                          *
 *   This program is distributed in the hope that it will be useful,        *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 *   MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                           *
 *                                                                          *
 *   You should have received a copy of the GNU General Public License      *
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.  *
 *                                                                          *
 ****************************************************************************/


#include "themeparser.h"
#include "cobrasettings.h"

#include <QFile>
#include <QTextStream>
#include <QDesktopWidget>

#include <QDebug>

ThemeParser::ThemeParser() {

    themePath_      = CobraSettings().getThemePath();
    themeFile_      = CobraSettings().getThemeFile();

    uncommentTheme();
    resetValues();
}

void ThemeParser::uncommentTheme() {

    QFile file(themeFile_);
    QString data;

    if(file.exists()) {

        file.open(QIODevice::ReadOnly);
        QTextStream stream(&file);
        data = stream.readAll();
        file.close();

    }

    QString bad0("/*");
    QString bad1("*/");

    QStringList comment_begin;
    QStringList comment_end;

    for(int i = 0; i < data.length() - 1; i++) {

        QString a = data.at(i);
        QString b = data.at(i + 1);
        QString c = a.append(b);

        if(c.contains(bad0)) {

            comment_begin.append(QString::number(i));

        }

        if(c.contains(bad1)) {

            comment_end.append(QString::number(i));

        }
    }

    if(comment_begin.length() != comment_end.length()) {

        themeContent_ = "i can't parse this theme! broken `comment policy`";

    } else {

        for(int i = comment_begin.length() - 1; i >= 0; i--) {

            QString start = comment_begin.at(i);
            QString end   = comment_end.at(i);
            int aa        = start.toInt();
            int bb        = end.toInt() + 2; // + 2 is for "*/" itself

            themeContent_ = data.remove(aa, bb - aa);

        }
    }

    formatRules();
}

// mess, clean me
void ThemeParser::formatRules() {

    QString data = themeContent_;
    data.prepend("}");
    data.append("{");

    QStringList block_name;
    QStringList block_content;
    QString     block_begin("{");
    QString     block_end("}");
    QStringList starting_points;
    QStringList ending_points;
    QStringList mock_list;

    for(int i = 0; i < data.length(); i++) {

        QString a = data.at(i);

        if(a.contains(block_end)) {

            ending_points << QString::number(i);

        }

        if(a.contains(block_begin)) {

            starting_points << QString::number(i);

        }
    }

    for(int i = 0; i < starting_points.length(); i++) {

        QString clunky;
        int s;
        int e;

        s = starting_points.at(i).toInt();
        e = ending_points.at(i).toInt() + 1;

        for (int j = e; j < s; j++) {

            clunky.append(data.at(j));
        }

        clunky.remove("\n");
        block_name << clunky;

    }

    for(int k = 0; k < starting_points.length() - 1; k++) {

        QString clunky;

        int s = starting_points.at(k).toInt() + 1;
        int e = ending_points.at(k + 1).toInt();

        for (int j = s; j < e; j++) {

            clunky.append(data.at(j));
        }

        clunky.remove("\n");
        block_content << clunky;

    }

    for(int i = 0; i < block_content.length(); i++) {

        QStringList bb = block_content.at(i).split(";");
        QStringList cc = block_name.at(i).split(",");

        for(int k = 0; k < cc.length(); k++) {

            for(int j = 0; j < bb.length(); j++) {

                QString a = bb.at(j);
                QString b = cc.at(k).trimmed();

                a.replace("  ", "");
                QString n = a.prepend("-")
                        .prepend(b).append(";")
                        .replace("px;",";")
                        .replace("pt;",";")
                        .replace(":hover", "_hover")
                        .replace(":focus", "_focus");

                if(n.contains(":")) {

                    mock_list.append(n);

                }
            }
        }
    }

    for(int i = 0; i < mock_list.length(); i++) {

        QString a = mock_list.at(i);

        if( (a.at(0) == QString("#")) | (a.at(0) == QString(".")) ) {

            a.remove(0,1);

        }

        if(!a.contains(": ")) {

            a.replace(":", ": ");

        }

        a.replace("\"", "");

        QStringList xx_;
        xx_ = a.split(": ");
        QString n0 = xx_.at(0); // property
        n0.replace("-","_").append(": ");
        QString n1 = xx_.at(1); // value
        n1.replace(";","");

        if(n0.contains("background_image")) {

            n1.prepend(themePath_).prepend("file://").replace(" ", "%20");

        }

        a.clear();
        a.append(n0.toLower()).append(n1);

        themeRules_.append(a);

    }
}

QString ThemeParser::getThemeContent() {

    return themeContent_;
}

QStringList ThemeParser::getThemeRules() {

    return themeRules_;
}

QStringList ThemeParser::getDefaultRules() {

    resetValues();
    return defaultRules_;

}

int ThemeParser::getThemeLength() {

    return themeRules_.length();
}

void ThemeParser::setDefaultValues(QWidget *widget, QObject *&qmlobject) {

    resetValues();
    CobraSettings settings;

    QDesktopWidget qw;
    QRect mainScreenSize = qw.availableGeometry(qw.primaryScreen());

    for(int i = 0; i < defaultRules_.length(); i++) {

        QString m_ = defaultRules_.at(i);
        QStringList n_ = m_.split(": ");

        QString property_;
        QString value_;

        property_ = n_.at(0);
        value_ = n_.at(1);

        QByteArray aa = value_.toLatin1().trimmed();
        const char *c_value_ = aa.data();

        QByteArray ba = property_.toLower().toLatin1().trimmed().replace(" ","");
        const char *c_property_ = ba.data();


        if(property_.toLower().contains("general_width")) {

            widget->resize(QString(c_value_).toInt(), widget->height());
            widget->move(mainScreenSize.width() - widget->width(),0);
            qmlobject->setProperty("global_width",QString::number(widget->width()));

        } else if(property_.toLower().contains("general_alignment") && QString(c_value_) == "left") {

            widget->move(0,0);

        } else if(property_.toLower().contains("general_extended_height") && QString(c_value_) == "false") {

            CobraSettings n_;

            int apps_height   = n_.getApplicationsHeight(widget->width());
            int places_height = n_.getPlacesHeight(widget->width());
            int cal_height    = widget->width() / 3 + widget->width() / 10;
            int pins_height   = widget->width() / 8 + (widget->width() / 20);
            int sum           = apps_height + places_height + cal_height + pins_height;

            qmlobject->setProperty("general_extended_height", "false");
            widget->resize(widget->width(),sum);

        } else if(property_.toLower().contains("general_extended_height") && QString(c_value_) == "true") {

            qmlobject->setProperty("general_extended_height", "true");
            widget->resize(widget->width(),mainScreenSize.height());

        } else {

            qmlobject->setProperty(c_property_, c_value_);

        }

        qmlobject->setProperty("placeHeight", settings.getPlacesHeight(widget->width()));
        qmlobject->setProperty("applicationHeight", settings.getApplicationsHeight(widget->width()));

    }

}

void ThemeParser::setThemeValues(QWidget *widget, QObject *&qmlobject) {

    CobraSettings settings;
    QDesktopWidget qw;
    QRect mainScreenSize = qw.availableGeometry(qw.primaryScreen());

    for(int i = 0; i < themeRules_.length(); i++) {

        QString m_ = themeRules_.at(i);
        QStringList n_ = m_.split(": ");

        QString property_;
        QString value_;

        property_ = n_.at(0);
        value_ = n_.at(1);

        QByteArray aa = value_.toLatin1().trimmed();
        const char *c_value_ = aa.data();

        QByteArray ba = property_.toLower().toLatin1().trimmed().replace(" ","");
        const char *c_property_ = ba.data();

        if(property_.toLower().contains("general_width")) {

            widget->resize(QString(c_value_).toInt(),widget->height());
            widget->move(mainScreenSize.width() - widget->width(),0);
            qmlobject->setProperty("global_width",QString::number(widget->width()));

        } else if(property_.toLower().contains("general_alignment") && QString(c_value_) == "left") {

            widget->move(0,0);

        } else if(property_.toLower().contains("general_extended_height") && QString(c_value_) == "false") {

            CobraSettings n_;

            int apps_height   = n_.getApplicationsHeight(widget->width());
            int places_height = n_.getPlacesHeight(widget->width());
            int cal_height    = widget->width() / 3 + widget->width() / 10;
            int pins_height   = widget->width() / 8 + (widget->width() / 20);
            int sum           = apps_height + places_height + cal_height + pins_height;

            widget->resize(widget->width(),sum);
            qmlobject->setProperty("general_extended_height", "false");

        } else if(property_.toLower().contains("general_extended_height") && QString(c_value_) == "true") {

            qmlobject->setProperty("general_extended_height", "true");
            widget->resize(widget->width(),mainScreenSize.height());

        } else {

            qmlobject->setProperty(c_property_, c_value_);

        }
    }

    qmlobject->setProperty("placeHeight", settings.getPlacesHeight(widget->width()));
    qmlobject->setProperty("applicationHeight", settings.getApplicationsHeight(widget->width()));

}

void ThemeParser::resetValues() {


    defaultRules_
            << "calendar_background_color: #00000000"
            << "calendar_background_image: "
            << "calendar_border_color: #00000000"
            << "calendar_border_width: 0"
            << "calendar_image_opacity: 1"
            << "calendar_border_radius: 0"

            << "date_color: #aaffffff"
            << "date_font_family: Oxygen-Sans"

            << "time_color: #aaffffff"
            << "time_font_family: Oxygen-Sans"

            << "pins_background_color: #00000000"
            << "pins_background_image: "
            << "pins_border_color: #00000000"
            << "pins_border_width: 0"
            << "pins_image_opacity: 1"
            << "pins_border_radius: 0"

            << "pin1_background_image: "
            << "pin1_border_width: 2"
            << "pin1_background_gradient_top: #333"
            << "pin1_background_gradient_bottom: #000"
            << "pin1_border_gradient_top: #000"
            << "pin1_border_gradient_bottom: #44ff0000"
            << "pin1_image_opacity: 1"
            << "pin1_border_radius: 40"
            << "pin1_inner_border_color: #000"
            << "pin1_inner_border_width: 0"
            << "pin1_outer_border_color: #000"
            << "pin1_outer_border_width: 0"

            << "pin2_background_image: "
            << "pin2_border_width: 2"
            << "pin2_background_gradient_top: #333"
            << "pin2_background_gradient_bottom: #000"
            << "pin2_border_gradient_top: #000"
            << "pin2_border_gradient_bottom: #44ff0000"
            << "pin2_image_opacity: 1"
            << "pin2_border_radius: 40"
            << "pin2_inner_border_color: #000"
            << "pin2_inner_border_width: 0"
            << "pin2_outer_border_color: #000"
            << "pin2_outer_border_width: 0"

            << "pin3_background_image: "
            << "pin3_border_width: 2"
            << "pin3_background_gradient_top: #333"
            << "pin3_background_gradient_bottom: #000"
            << "pin3_border_gradient_top: #000"
            << "pin3_border_gradient_bottom: #44ff0000"
            << "pin3_image_opacity: 1"
            << "pin3_border_radius: 40"
            << "pin3_inner_border_color: #000"
            << "pin3_inner_border_width: 0"
            << "pin3_outer_border_color: #000"
            << "pin3_outer_border_width: 0"

            << "applications_background_color: #00000000"
            << "applications_background_image: "
            << "applications_border_color: #00000000"
            << "applications_border_width: 0"
            << "applications_image_opacity: 1"
            << "applications_border_radius: 0"

            << "places_background_color: #00000000"
            << "places_background_image: "
            << "places_border_color: #00000000"
            << "places_border_width: 0"
            << "places_image_opacity: 1"
            << "places_border_radius: 0"

            << "general_background_color: #aa000000"
            << "general_border_color: #000000"
            << "general_background_image: "
            << "general_border_radius: 0"
            << "general_border_width: 0"
            << "general_image_opacity: 1"
            << "general_width: 200"
            << "general_extended_height: true"

            << "applicationbutton_background_gradient_bottom: #333"
            << "applicationbutton_background_gradient_top: #00555555"
            << "applicationbutton_border_gradient_bottom: #555"
            << "applicationbutton_border_gradient_top: #000"
            << "applicationbutton_border_radius: 8"
            << "applicationbutton_border_width: 0"
            << "applicationbutton_color: #000"
            << "applicationbutton_font_family: Sans"
            << "applicationbutton_icon_grayscale: false"
            << "applicationbutton_inner_border_color: #000"
            << "applicationbutton_inner_border_width: 0"
            << "applicationbutton_outer_border_color: #000"
            << "applicationbutton_outer_border_width: 0"
            << "applicationbutton_text_align: center"

            << "applicationbutton_focus_background_gradient_bottom: #333"
            << "applicationbutton_focus_background_gradient_top: #555"
            << "applicationbutton_focus_border_gradient_bottom: #555"
            << "applicationbutton_focus_border_gradient_top: #000"
            << "applicationbutton_focus_border_radius: 8"
            << "applicationbutton_focus_border_width: 0"
            << "applicationbutton_focus_color: #000"
            << "applicationbutton_focus_font_family: Sans"
            << "applicationbutton_focus_icon_grayscale: false"
            << "applicationbutton_focus_inner_border_color: #000"
            << "applicationbutton_focus_inner_border_width: 0"
            << "applicationbutton_focus_outer_border_color: #000"
            << "applicationbutton_focus_outer_border_width: 0"
            << "applicationbutton_focus_text_align: center"

            << "applicationbutton_hover_background_gradient_bottom: #333"
            << "applicationbutton_hover_background_gradient_top: #00555555"
            << "applicationbutton_hover_border_gradient_bottom: #555"
            << "applicationbutton_hover_border_gradient_top: #000"
            << "applicationbutton_hover_border_radius: 8"
            << "applicationbutton_hover_border_width: 0"
            << "applicationbutton_hover_color: #000"
            << "applicationbutton_hover_font_family: Sans"
            << "applicationbutton_hover_icon_grayscale: false"
            << "applicationbutton_hover_inner_border_color: #000"
            << "applicationbutton_hover_inner_border_width: 0"
            << "applicationbutton_hover_outer_border_color: #000"
            << "applicationbutton_hover_outer_border_width: 0"
            << "applicationbutton_hover_text_align: center"

            << "placebutton_background_gradient_bottom: #333"
            << "placebutton_background_gradient_top: #555"
            << "placebutton_border_gradient_bottom: #555"
            << "placebutton_border_gradient_top: #000"
            << "placebutton_border_radius: 8"
            << "placebutton_border_width: 0"
            << "placebutton_color: #000"
            << "placebutton_font_family: Sans"
            << "placebutton_icon_grayscale: false"
            << "placebutton_inner_border_color: #000"
            << "placebutton_inner_border_width: 0"
            << "placebutton_outer_border_color: #000"
            << "placebutton_outer_border_width: 0"
            << "placebutton_text_align: center"

            << "placebutton_focus_background_gradient_bottom: #333"
            << "placebutton_focus_background_gradient_top: #555"
            << "placebutton_focus_border_gradient_bottom: #555"
            << "placebutton_focus_border_gradient_top: #000"
            << "placebutton_focus_border_radius: 8"
            << "placebutton_focus_border_width: 0"
            << "placebutton_focus_color: #000"
            << "placebutton_focus_font_family: Sans"
            << "placebutton_focus_icon_grayscale: false"
            << "placebutton_focus_inner_border_color: #000"
            << "placebutton_focus_inner_border_width: 0"
            << "placebutton_focus_outer_border_color: #000"
            << "placebutton_focus_outer_border_width: 0"
            << "placebutton_focus_text_align: center"

            << "placebutton_hover_background_gradient_bottom: #333"
            << "placebutton_hover_background_gradient_top: #555"
            << "placebutton_hover_border_gradient_bottom: #555"
            << "placebutton_hover_border_gradient_top: #000"
            << "placebutton_hover_border_radius: 8"
            << "placebutton_hover_border_width: 0"
            << "placebutton_hover_color: #000"
            << "placebutton_hover_font_family: Sans"
            << "placebutton_hover_icon_grayscale: false"
            << "placebutton_hover_inner_border_color: #000"
            << "placebutton_hover_inner_border_width: 0"
            << "placebutton_hover_outer_border_color: #000"
            << "placebutton_hover_outer_border_width: 0"
            << "placebutton_hover_text_align: center";

}
