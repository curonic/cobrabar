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

CobraSettings::CobraSettings() {

    settings_file = QString(QStandardPaths::standardLocations
                            (QStandardPaths::ConfigLocation)[0])
            .append(QDir::separator())
            .append("CobraBar")
            .append(QDir::separator())
            .append("settings.xml");

    icon_dir_path = QString(QStandardPaths::standardLocations
                            (QStandardPaths::ConfigLocation)[0])
            .append(QDir::separator())
            .append("CobraBar")
            .append(QDir::separator())
            .append("icons")
            .append(QDir::separator());

    themes_dir = QString(QStandardPaths::standardLocations
                         (QStandardPaths::ConfigLocation)[0])
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

    QDomNodeList a_items = document.firstChildElement().elementsByTagName("application");
    QDomNodeList p_items = document.firstChildElement().elementsByTagName("place");
    QDomNodeList t_items = document.firstChildElement().elementsByTagName("theme");

    if(a_items.count() > 0) {

        applications_count = a_items.count();

        QStringList temp_app_list;

        for(int i = 0; i < applications_count; i++) {

            QString exec = a_items.at(i).attributes().namedItem("exec").toAttr().value();
            QString icon = a_items.at(i).attributes().namedItem("icon").toAttr().value();
            QString tool = a_items.at(i).attributes().namedItem("tooltip").toAttr().value();

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

        for( int i = 0; i < p_items.count(); i++) {

            QString path  = p_items.at(i).attributes().namedItem("path").toAttr().value();
            QString text  = p_items.at(i).attributes().namedItem("icon").toAttr().value();
            QString label = p_items.at(i).attributes().namedItem("label").toAttr().value();
            QString tool  = p_items.at(i).attributes().namedItem("tooltip").toAttr().value();

            QString b;

            b.append(path)
             .append(",").append(text)
             .append(",").append(label)
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

        theme_name = t_items.at(0).attributes().namedItem("id").toAttr().value();

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

    return getThemePath().append("style.css");

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

int CobraSettings::getApplicationsHeight( int parent_width, int border_width ) {

    int spacing = 4;
    double w = ((double)parent_width - (double)border_width * 2) / 4 - 4;
    int line_count = applications_count / 4;
    if (line_count * 4 >= applications_count)
        return qRound(w) * line_count + (line_count + 1) * spacing;
     else
        return qRound(w) * (line_count + 1) + (line_count + 2) * spacing;

}

int CobraSettings::getPlacesHeight( int parent_width, int border_width ) {

    int spacing = 4;
    double h = ((double)parent_width - (double)border_width * 2) / 6;
    return places_count * qRound(h) + spacing * (places_count + 1);

}

int CobraSettings::getTimeHeight( int parent_width, int border_width ) {

    return (parent_width - border_width * 2) / 6;

}

int CobraSettings::getDateHeight( int parent_width, int border_width ) {

    return (parent_width - border_width * 2) / 6 * 0.6;

}

int CobraSettings::getPinsHeight( int parent_width, int border_width ) {

    return (parent_width - border_width * 2) / 8;

}
