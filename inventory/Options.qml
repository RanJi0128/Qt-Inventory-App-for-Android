import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12


Page {
    id:option_page
    signal signalExit
    signal pageShow
    visible: false
//    width: 432
//    height: 768

    property string ip_address: ""
    property string userName: ""
    property string sharedFolder: ""
    property string password: ""
    property int logoffTime: 5

    width: Screen.width
    height: Screen.height
    Component.onCompleted: {

        busy_indicator.running=false
    }
    function androidBatteryStateChanged(level, onCharge)
    {
        _general_page.androidBatteryStateChanged(level, onCharge)

    }
    function androidSystemInformation(body)
    {
        _general_page.androidSystemInformation(body)

    }
    BusyIndicator {

        id: busy_indicator
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        running: true

        contentItem: Item {
            id: element
            implicitWidth: option_page.width*15/100
            implicitHeight: implicitWidth

            Item {
                id: item_indicator
                x: parent.width / 2 - implicitWidth / 2
                y: parent.height / 2 - implicitHeight / 2
                width: parent.implicitWidth
                height: parent.implicitHeight
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: busy_indicator.running ? 1 : 0

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 250
                    }
                }

                RotationAnimator {
                    target: item_indicator
                    running: busy_indicator.visible && busy_indicator.running
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1250
                }

                Repeater {
                    id: repeater
                    model: 6

                    Rectangle {
                        x: item_indicator.width / 2 - width / 2
                        y: item_indicator.height / 2 - height / 2
                        implicitWidth: item_indicator.width*16/100
                        implicitHeight: implicitWidth
                        radius: item_indicator.height*8/100
                        color: "#21be2b"
                        transform: [
                            Translate {
                                y: -Math.min(item_indicator.width, item_indicator.height) * 0.5 + item_indicator.height*8/100
                            },
                            Rotation {
                                angle: index / repeater.count * 360
                                origin.x: item_indicator.width*8/100
                                origin.y: item_indicator.height*8/100
                            }
                        ]
                    }
                }
            }
        }
    }


    SwipeView {
            id: swipeView
            anchors.fill: parent
            currentIndex: tabBar.currentIndex

            GeneralForm {

                id : _general_page

                onSignalExit:{
                    option_page.signalExit()
                }
              }
            AdvancedForm{
                id : _advanced_page
                onSignalExit:{
                    option_page.signalExit()
                }

            }


        }

    onPageShow:{
        _advanced_page.ip_address = ip_address
        _advanced_page.userName = userName
        _advanced_page.sharedFolder = sharedFolder
        _advanced_page.password = password
        _advanced_page.logoffTime = logoffTime
    }
    footer: TabBar {
        id: tabBar
        height: parent.height*6/100
        width: parent.width
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        TabButton {
            id: general_button
            x: 0
            width: tabBar.width/4
            height: tabBar.height
            text: qsTr("General")
            font.pixelSize: parent.height*36.5/100
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            font.capitalization: Font.Capitalize
        }
        TabButton {
            id: advanced_button
            x: tabBar.width/4
            width: tabBar.width/4
            height: tabBar.height
            text: qsTr("Advanced")
            font.pixelSize: parent.height*36.5/100
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            font.capitalization: Font.Capitalize
        }
        TabButton {
            id: language_button
            x: tabBar.width/2
            width: tabBar.width/4
            height: tabBar.height
            text: qsTr("Language")
            font.pixelSize: parent.height*36.5/100
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            font.capitalization: Font.Capitalize
        }
        TabButton {
            id: statue_button
            x: tabBar.width*3/4
            width: tabBar.width/4-4
            height: tabBar.height
            text: qsTr("Statue")
            font.pixelSize: parent.height*36.5/100
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            font.capitalization: Font.Capitalize
        }


    }


}
