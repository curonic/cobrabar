#ifndef THEMEPARSER_H
#define THEMEPARSER_H

#include <QStringList>
#include <QWidget>

class ThemeParser {

public:
    ThemeParser();
    void setThemeRules(QWidget *widget, QObject *&qmlobject);

private:
    void        formatRules();
    void        mergeRules();

    QStringList getComboRules();
    QStringList resetValues();

    QString     themeFile_;
    QString     themePath_;
    QStringList themeRules_;
    QStringList combinedRules;

    int globalHeight_;
    int globalWidth_;
    int globalAWidth_;
    int globalAlignment_;
    int globalBorderWidth_;
    int globalAHeight_;
};

#endif // THEMEPARSER_H
