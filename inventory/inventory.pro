

QT += quick androidextras sql
CONFIG += c++11


# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += main.cpp \
    customuser.cpp \
    enhancedqmlapplicationengine.cpp \
    tablemodel.cpp \
    inventorytablemodel.cpp \
    shippingtablemodel.cpp \
    database.cpp \
    logintablemodel.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += tablemodel.h \
    customuser.h \
    enhancedqmlapplicationengine.h \
    include.h \
    inventorytablemodel.h \
    shippingtablemodel.h \
    database.h \
    logintablemodel.h

DISTFILES += android/AndroidManifest.xml \
    android/assets/hide.png \
    android/assets/unhide.png \
    android/src/com/jni/systeminfo/AppActivity.java \
    android/src/com/jni/systeminfo/BatteryLevelListener.java \
    android/src/com/jni/systeminfo/DeviceInformation.java \
    android/libs/jcifs-1.3.19.jar \
    android/src/com/jni/systeminfo/NetworkManager.java \
    android/assets/db/inventory.db \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/src/com/jni/systeminfo/OpenOtherApp.java

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android


