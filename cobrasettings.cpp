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


#include "cobrasettings.h"

#include <QDomDocument>
#include <QFile>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

CobraSettings::CobraSettings() {

    settings_file = QString(QStandardPaths::standardLocations
                            (QStandardPaths::ConfigLocation).at(0))
            .append(QDir::separator())
            .append("CobraBar")
            .append(QDir::separator())
            .append("settings.xml");


    icon_dir_path = QString(QStandardPaths::standardLocations
                            (QStandardPaths::ConfigLocation).at(0))
            .append(QDir::separator())
            .append("CobraBar")
            .append(QDir::separator())
            .append("icons")
            .append(QDir::separator());

    themes_dir = QString(QStandardPaths::standardLocations
                         (QStandardPaths::ConfigLocation).at(0))
            .append(QDir::separator())
            .append("CobraBar")
            .append(QDir::separator())
            .append("themes")
            .append(QDir::separator());

    readSettings();
}

void CobraSettings::readSettings() {

    QDomDocument document;

    QString path(settings_file);

    QFile file(path);
    file.open(QIODevice::ReadOnly);
    document.setContent(&file);
    file.close();

    auto root    = document.firstChildElement();
    auto a_items = root.elementsByTagName("application");
    auto p_items = root.elementsByTagName("place");
    auto t_items = root.elementsByTagName("theme");

    if(a_items.count() > 0) {

        applications_count = a_items.count();

        QStringList temp_app_list;

        for(int i = 0; i < applications_count; i++) {

            auto node = a_items.at(i);
            auto map  = node.attributes();
            auto exec = map.namedItem("exec").toAttr().value();
            auto icon = map.namedItem("icon").toAttr().value();
            auto tool = map.namedItem("tooltip").toAttr().value();

            QString b;

            b.append(exec).append(",").append(icon).append(",").append(tool);

            b.replace("~", QString(QStandardPaths::standardLocations(
                                       QStandardPaths::HomeLocation).at(0)));

            temp_app_list.append(b);

        }

        application_list = temp_app_list;

    } else {

        applications_count = -1;
        application_list << "applications are empty or not provided";

    }

    if(p_items.count() > 0) {

        places_count = p_items.count();

        QStringList temp_places_list;

        for( int i = 0; i < places_count; i++) {

            auto node = p_items.at(i);
            auto map  = node.attributes();
            auto path = map.namedItem("path").toAttr().value();
            auto text = map.namedItem("text").toAttr().value();
            auto tool = map.namedItem("tooltip").toAttr().value();

            QString b;

            b.append(path)
                    .append(",").append(text)
                    .append(",").append(tool);

            b.replace("~", QString(QStandardPaths::standardLocations(
                                       QStandardPaths::HomeLocation).at(0)));


            temp_places_list.append(b);
        }

        places_list = temp_places_list;

    } else {

        places_count = -1;
        places_list << "places are empty or not provided";

    }

    if(t_items.count() > 0) {

        auto node = t_items.at(0);
        auto map  = node.attributes();
        auto id = map.namedItem("id").toAttr().value();

        theme_name = id;

    } else {

        theme_name = "theme is not set";

    }


}

QString CobraSettings::getSettingsFile() {

    return settings_file;

}

QString CobraSettings::getIconsDir() {

    return icon_dir_path;

}

QString CobraSettings::getThemesDir() {

    return themes_dir;

}

QString CobraSettings::getThemeName() {

    return theme_name;

}

QString CobraSettings::getThemePath() {

    return themes_dir + theme_name + QDir::separator();

}

QString CobraSettings::getThemeFile() {

    auto m_ = themes_dir.append(theme_name).append(QDir::separator()).append("style.txt");

    return m_;

}

QStringList CobraSettings::getApplicationsList() {

    return application_list;

}

QStringList CobraSettings::getPlacesList() {

    return places_list;

}

int CobraSettings::getApplicationsCount() {

    return applications_count;

}

int CobraSettings::getPlacesCount() {

    return places_count;

}

int CobraSettings::getApplicationsHeight( int parent_width ) {

    auto item_count = applications_count;
    auto line_count = item_count / 4;

    if (line_count * 4 >= applications_count) {

        return ((parent_width / 5) + (parent_width / 20)) * line_count;

    } else {

        return ((parent_width / 5) + (parent_width / 20)) * (line_count + 1);
    }
}

int CobraSettings::getPlacesHeight( int parent_width ) {

    return (parent_width / 8 + 3) * places_count + parent_width / 40 + parent_width / 20;

}
