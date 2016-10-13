#ifndef THEMEPARSER_H
#define THEMEPARSER_H

#include <QString>
#include <QStringList>
#include <QWidget>
#include <QObject>

class ThemeParser {

public:
    ThemeParser();
    QString     getThemeContent();
    int         getThemeLength();
    QStringList getThemeRules();
    QStringList getDefaultRules();

    void setDefaultValues(QWidget *widget, QObject *&qmlobject);
    void setThemeValues(QWidget *widget, QObject *&qmlobject);

private:
    void        resetValues();
    void        formatRules();
    void        uncommentTheme();
    QStringList defaultRules_;
    QString     themeContent_;
    QString     themeFile_;
    QString     themePath_;
    QStringList themeRules_;

};

#endif // THEMEPARSER_H
