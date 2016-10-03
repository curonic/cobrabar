#ifndef COBRASETTINGS_H
#define COBRASETTINGS_H

#include <QStringList>

class CobraSettings {

public:
    CobraSettings();
    int         getApplicationsCount();
    int         getApplicationsHeight(int parent_width);
    QStringList getApplicationsList();
    QString     getIconsDir();
    int         getPlacesCount();
    int         getPlacesHeight(int parent_width);
    QStringList getPlacesList();
    QString     getSettingsFile();
    QString     getThemesDir();
    QString     getThemeName();
    QString     getThemePath();
    QString     getThemeFile();

private:
    void        readSettings();
    int         applications_count;
    int         places_count;
    QString     settings_file;
    QString     icon_dir_path;
    QStringList application_list;
    QStringList places_list;
    QString     themes_dir;
    QString     theme_name;

};

#endif // COBRASETTINGS_H
