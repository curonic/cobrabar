#ifndef THEMEPARSER_H
#define THEMEPARSER_H

#include <QString>
#include <QStringList>

class ThemeParser {

public:
    ThemeParser();
    QString     getThemeContent();
    int         getThemeLength();
    QStringList getThemeRules();

private:
    void        formatRules();
    void        uncommentTheme();
    QString     themeContent_;
    QString     themeFile_;
    QString     themePath_;
    QStringList themeRules_;

};

#endif // THEMEPARSER_H
