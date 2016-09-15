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

#include <iostream>

#include <QFile>
#include <QDir>
#include <QDirIterator>
#include <QDomElement>
#include <QDomNode>
#include <QStandardPaths>
#include <QTextStream>


ThemeParser::ThemeParser() {

    CobraSettings m_;

    themePath_      = m_.getThemePath();
    themeFile_      = m_.getThemeFile();

    uncommentTheme();

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

    for(int i = 0; i < data.length() -1; i++) {

        QString a;
        QString b;
        a = data.at(i);
        b = data.at(i+1);

        QString c = a.append(b);

        if(c.contains(bad0)) {

            comment_begin.append(QString::number(i));

        }

        if(c.contains(bad1)) {

            comment_end.append(QString::number(i));

        }
    }

    if(comment_begin.length() != comment_end.length()) {

        themeContent_ = "i can't parse this theme! broken `comment` policy";

    } else {

        for(int i = comment_begin.length() - 1; i >= 0; i--) {

            QString start = comment_begin.at(i);
            QString end   = comment_end.at(i);
            int aa        = start.toInt();
            int bb        = end.toInt() + 2; // + 2 is for "*/" itself

            themeContent_ = data.remove(aa,bb-aa);

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

        QString a;
        a = data.at(i);

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
        int s;
        int e;
        s = starting_points.at(k).toInt() + 1;
        e = ending_points.at(k + 1).toInt();

        for (int j = s; j < e; j++) {

            clunky.append(data.at(j));
        }

        clunky.remove("\n");
        block_content << clunky;

    }

    for(int i = 0; i < block_content.length(); i++) {

        QStringList bb;
        bb = block_content.at(i).split(";");

        QStringList cc;
        cc = block_name.at(i).split(",");

        for(int k = 0; k < cc.length(); k++) {

            for(int j = 0; j < bb.length(); j++) {

                QString a;
                QString b;
                b = cc.at(k).trimmed();
                a = bb.at(j);
                a.replace("  ","");
                QString n = a.prepend("-").prepend(b).append(";")
                        /* special cases */
                        .replace(":hover","_hover")
                        .replace(":focus","_focus");


                if(n.contains(":")) {

                    mock_list.append(n);

                }
            }
        }
    }

    for(int i = 0; i < mock_list.length(); i++) {

        QString a;
        a = mock_list.at(i);

        if(a.at(0) == QString("#") | a.at(0) == QString(".")) {

            a.remove(0,1);

        }

        if(!a.contains(": ")) {

            a.replace(":",": ");
        }

        a.replace(";","");
        a.replace("-","_"); // `font-family: sans-serif` ???
        a.replace("\"","");

        if(a.contains("background_image")) {

            QStringList addPath_;
            QString temp_;
            QString f_;

            addPath_ = a.split(":");
            temp_    = addPath_.at(1).trimmed();
            temp_.prepend(themePath_).prepend("file://");

            f_.append(addPath_.at(0)).append(": ").append(temp_);
            a = f_;

        }

        themeRules_.append(a);

    }
}

QString ThemeParser::getThemeContent() {

    return themeContent_;
}

QStringList ThemeParser::getThemeRules() {

    return themeRules_;
}

int ThemeParser::getThemeLength() {

    return themeRules_.length();
}
