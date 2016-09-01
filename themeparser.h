#ifndef THEMEPARSER_H
#define THEMEPARSER_H

#include <QString>
#include <QStringList>

class ThemeParser {

public:
    ThemeParser();

    QString     themeContent_;
    QStringList themeRules_;

    QString     getThemeContent();
    QStringList getThemeRules();
    int         getThemeLength();

private:
    QString     themePath_;
    QString     themeFile_;

    void uncommentTheme();
    void formatRules();

};

#endif // THEMEPARSER_H
