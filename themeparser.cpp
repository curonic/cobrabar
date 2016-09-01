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
#include <QDir>
#include <QDirIterator>
#include <QDomElement>
#include <QDomNode>
#include <QStandardPaths>
#include <QTextStream>
//#include <QDebug>


ThemeParser::ThemeParser() {

    auto m_ = new CobraSettings;

    themePath_      = m_->getThemePath();
    themeFile_      = m_->getThemeFile();

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

    if(themeContent_.length() > 0) {

        QStringList a;

        a = themeContent_.split('\n');

        for( int i = 0; i < a.length(); i++) {

            if(a.at(i).contains(';') && a.at(i).contains(':') && a.at(i).contains('.')) {

                QString m_;
                m_ = ".";

                QString temp_w;
                temp_w = a.at(i).trimmed();
                temp_w.replace(temp_w.indexOf(m_),m_.size(), QString(","));
                temp_w.replace(":",",");
                temp_w.replace(", ",",");
                temp_w.replace(";","");
                temp_w.replace("-","_"); // qml properties can't handle '-'
                temp_w.replace("\"",""); // remove silly quotes around the attributes

                /* remodel and make resources (like image paths) absolute */

                if(temp_w.contains("background_image")) {

                    QStringList addPath_;
                    addPath_ = temp_w.split(",");
                    QString temp_;
                    temp_ = addPath_.at(2).trimmed();
                    temp_.prepend(themePath_).prepend("file://");

                    QString f_;

                    f_.append(addPath_.at(0))
                            .append(",")
                            .append(addPath_.at(1))
                            .append(",")
                            .append(temp_);

                    temp_w = f_;

                }

                themeRules_.append(temp_w);
            }
        }
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
