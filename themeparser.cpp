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

ThemeParser::ThemeParser() {

    QDesktopWidget d;

    themePath_     = CobraSettings().getThemePath();
    themeFile_     = CobraSettings().getThemeFile();
    globalHeight_  = d.availableGeometry(d.primaryScreen()).height();
    globalAWidth_  = d.availableGeometry(d.primaryScreen()).width();

}

QStringList ThemeParser::getComboRules() {

    mergeRules();
    return combinedRules;

}

void ThemeParser::formatRules() {

    themeRules_.clear();

    QString content;
    QFile file(themeFile_);

    if(file.exists()) {

        file.open(QIODevice::ReadOnly);
        QTextStream stream(&file);
        content = stream.readAll();
        file.close();

    }

    QStringList c_b; // comment begin
    QStringList c_e; // comment end

    for(int i = 0; i < content.length() - 1; i++) {

        QString a(content[i]);
        a += content[i + 1];


        if(a.contains("/*"))
            c_b.append(QString::number(i));

        if(a.contains("*/"))
            c_e.append(QString::number(i));

    }

    if(c_b.length() == c_e.length())

        for(int i = c_b.length() - 1; i >= 0; i--)

            content.remove(c_b.at(i).toInt(), c_e.at(i).toInt() + 2 - c_b.at(i).toInt());


    /*  generate rules  */

    content.prepend("}");
    content.append("{");

    QStringList block_name;
    QStringList block_content;
    QStringList starting_points;
    QStringList ending_points;
    QStringList mock_list;

    for(int i = 0; i < content.length(); i++) {

        QString a = content.at(i);

        if(a.contains("}"))
            ending_points << QString::number(i);

        if(a.contains("{"))
            starting_points << QString::number(i);

    }

    for(int i = 0; i < starting_points.length(); i++) {

        QString clunky;

        for (int j = ending_points[i].toInt() + 1; j < starting_points[i].toInt(); j++)

            clunky.append(content[j]);

        clunky.remove("\n");
        block_name += clunky;

    }

    for(int i = 0; i < starting_points.length() - 1; i++) {

        QString clunky;

        for (int j = starting_points[i].toInt() + 1; j < ending_points[i + 1].toInt(); j++)

            clunky.append(content[j]);

        clunky.remove("\n");
        block_content += clunky;

    }


    /*  format generated rules  */

    for(int i = 0; i < block_content.length(); i++) {

        for(int j = 0; j < block_name.at(i).split(",").length(); j++) {

            for(int k = 0; k < block_content.at(i).split(";").length(); k++) {

                QString a = block_content.at(i).split(";").at(k);

                a.replace(" ", "");
                QString n = a.prepend("-")
                        .prepend(block_name.at(i).split(",").at(j).trimmed()).append(";")
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

        if( (mock_list[i].at(0) == QString("#")) | (mock_list[i].at(0) == QString(".")) ) {

            mock_list[i].remove(0,1);

        }

        if(!mock_list[i].contains(": ") && mock_list[i].contains(":")) {

            mock_list[i].replace(":", ": ");

        }

        mock_list[i].replace("\"", "");

        QString n0 = mock_list[i].split(": ").at(0); // property
        QString n1 = mock_list[i].split(": ").at(1); // value
        n0.replace("-","_").append(": ");
        n1.replace(";","");

        if(n0.contains("background_image")) {

            n1.prepend(themePath_).prepend("file://").replace(" ", "%20");

        }

        a.clear();
        a.append(n0.toLower()).append(n1);

        themeRules_.append(a);

    }
}

void ThemeParser::setThemeRules(QWidget *widget, QObject *&qmlobject) {

    getComboRules();

    widget->move(globalAlignment_, 0);
    widget->resize(globalWidth_, globalHeight_);

    qmlobject->setProperty("placeHeight", CobraSettings().getPlacesHeight(globalWidth_));
    qmlobject->setProperty("applicationHeight", CobraSettings().getApplicationsHeight(globalWidth_));
    qmlobject->setProperty("general_width", globalWidth_);

    for(int i = 0; i < combinedRules.length(); i++)

        qmlobject->setProperty(combinedRules[i].split(": ")[0].toLatin1().trimmed().data(),
                               combinedRules[i].split(": ")[1].toLatin1().trimmed());

}

QStringList ThemeParser::resetValues() {

    QStringList a;

    a << "calendar_background_color: #00000000"
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

      << "general_alignment: right"
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

    return a;
}

void ThemeParser::mergeRules() {

    combinedRules.clear();

    formatRules();

    QStringList defaultList(resetValues());

    QStringList numlist0;
    QStringList numlist1;

    for(int i = 0; defaultList.length() > i; i++) {

        for(int j = 0; themeRules_.length() > j; j++) {

            if(QString::compare(defaultList[i].split(": ")[0],themeRules_[j].split(": ")[0]) ==
                    QString::compare(themeRules_[j].split(": ")[0],defaultList[i].split(": ")[0])) {

                numlist0 += QString::number(i);
                numlist1 += QString::number(j);

            }
        }
    }

    for(int i = numlist0.length() - 1; i >= 0; i--)

        defaultList.removeAt(numlist0[i].toInt());


    for(int i = 0; numlist1.length() > i; i++)

        defaultList += themeRules_[numlist1[i].toInt()];


    for(int i = 0; i < defaultList.length(); i++)

        if(defaultList[i].split(": ")[0].contains("general_width"))

            globalWidth_ = defaultList[i].split(": ")[1].toInt();


    for(int i = 0; i < defaultList.length(); i++)

        if(defaultList[i].split(": ")[0].contains("general_alignment") &&
                defaultList[i].split(": ")[1].toLower().contains("left"))

            globalAlignment_ = 0;


        else if(defaultList[i].split(": ")[0].contains("general_alignment") &&
                defaultList[i].split(": ")[1].toLower().contains("right"))

            globalAlignment_ = globalAWidth_ - globalWidth_;

    combinedRules << defaultList;

}
