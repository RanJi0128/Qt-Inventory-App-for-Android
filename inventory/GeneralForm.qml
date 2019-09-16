
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Page {
    id: general_page
//    width: 432
//    height: 768
      width: Screen.width
      height: Screen.height
    signal signalExit
    function androidBatteryStateChanged(level, onCharge)
    {
        control.value = parseFloat(level)/100;
        battery_percent.text = qsTr("(On charging: " + (onCharge ? "Yes" : "No")+")");
    }
    function androidSystemInformation(body)
    {
        sysinfo_text.text = qsTr(body)

    }
    Image {
        id: image
        anchors.fill: parent
        anchors.right: parent.right
        source: "assets/login.png"
        fillMode: Image.Stretch
    }

    ProgressBar {
        id: control
        y: parent.height*45.5/100
        width: parent.width*86/100
        height: parent.height*3/100
        anchors.horizontalCenter: parent.horizontalCenter
        padding: parent.width*0.5/100

        background: Rectangle {
            implicitWidth: control.width*54/100
            implicitHeight: control.height*83/100
            color: "#e6e6e6"
            radius: control.width*1/100

        }

        contentItem: Item {
            id: element3

            Rectangle {
                id: rectangle
                width: control.visualPosition * parent.width
                height: parent.height
                radius: parent.width*1/100
                color: "#17a81a"

            }
            Text {
                id: element2
                text: qsTr(control.value*100+"%")
                anchors.verticalCenter: parent.verticalCenter
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: parent.height*65/100
            }
        }
    }
    Rectangle {
               id: sysifo_rect
               border.color: "black"
               border.width: parent.width*0.5/100
               y: parent.height*18.5/100
               width: parent.width*91/100
               height: parent.height*20.5/100
               anchors.horizontalCenter: parent.horizontalCenter

               Text {
                       id: sysinfo_text
                       width: sysifo_rect.width
                       height: sysifo_rect.height
                       text: qsTr("")
                       anchors.verticalCenter: parent.verticalCenter
                       wrapMode: Text.WrapAnywhere
                       anchors.horizontalCenter: parent.horizontalCenter
                       font.pixelSize: height*9.5/100
                       topPadding: height*9.5/100
                       leftPadding: width*2.5/100
                       rightPadding: width*5/100
                }

        }


    Label {
        id: battery_label
        y: parent.height*41.5/100
        width: parent.width*28/100
        height: parent.height*4.3/100
        text: qsTr("Main Battery:"+control.value*100+"%")
        font.pixelSize: parent.height*2/100
        font.bold: true
        anchors.horizontalCenterOffset: -parent.width*29.5/100
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: 0.7
        font.weight: Font.Bold
        font.italic: false
        fontSizeMode: Text.Fit
    }

    Label {
        id: battery_percent
        y: parent.height*41.5/100
        width: parent.width*32/100
        height: parent.height*4.3/100
        font.bold: true
        anchors.horizontalCenterOffset: parent.width*2/100
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.weight: Font.Bold
        opacity: 0.7
        font.italic: false
        font.pixelSize: parent.height*2/100
        fontSizeMode: Text.Fit
    }
    Label {
        id: title_label
        y: parent.height*11/100
        width: parent.width
        height: parent.height*6/100
        text: qsTr("General")
        opacity: 0.7
        font.pixelSize: height*60/100
        anchors.horizontalCenterOffset: 0
        fontSizeMode: Text.Fit
        font.weight: Font.Bold
        font.italic: true
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    RoundButton {
        id: menu_Button
        y: parent.height*69/100
        width: parent.width*27/100
        height: parent.height*7/100
        text: "Menu"
        anchors.horizontalCenterOffset: -parent.width*25/100
        font.pixelSize: height*39/100
        font.bold: true
        autoRepeat: false
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {

            general_page.signalExit()
        }

    }

    RoundButton {
        id: network_button
        y: parent.height*69/100
        width: parent.width*29/100
        height: parent.height*7/100
        text: "NetWork"
        font.bold: true
        anchors.horizontalCenterOffset: parent.width*22/100
        anchors.horizontalCenter: parent.horizontalCenter
        autoRepeat: false
        font.pixelSize: height*39/100
        onClicked: {

            custom_user.openNetworkSetting()
        }

    }


}
