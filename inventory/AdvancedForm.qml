import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3

Page {
    id: advanced_page
    width: 432
    height: 768
//      width: Screen.width
//      height: Screen.height

      property string ip_address: ""
      property string userName: ""
      property string sharedFolder: ""
      property string password: ""
      property int logoffTime: 5

    signal signalExit
    Component.onCompleted: {


    }
    Image {
        id: image
        anchors.fill: parent
        anchors.right: parent.right
        source: "assets/login.png"
        fillMode: Image.Stretch
    }
    Label {
        id: title_label
        y: parent.height*11/100
        width: parent.width
        height: parent.height*6/100
        text: qsTr("Advanced")
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
    ComboBox {
        id: task_control
        y: parent.height*18/100
        width: parent.width*41/100
        height: parent.height*5.5/100
        currentIndex: logoffTime == 0 ? 9 : logoffTime / 5 -1
        anchors.horizontalCenterOffset: parent.width*22.5/100
        font.pixelSize: height*37/100
        leftPadding: width*6/100
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        model: ["5 minutes", "10 minutes", "15 minutes", "20 minutes", "25 minutes", "30 minutes", "35 minutes", "40 minutes", "45 minutes", "Never"]
        delegate: ItemDelegate {
            width: task_control.width
            contentItem: Text {
                text: modelData
                color: "#000000"
                font: task_control.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            highlighted: task_control.highlightedIndex === index
        }

        indicator: Canvas {
            id: canvas
            x: task_control.width - width - task_control.rightPadding
            y: task_control.topPadding + (task_control.availableHeight - height) / 2
            width: task_control.width*8.5/100
            height: task_control.height*18.5/100
            contextType: "2d"

            Connections {
                target: task_control
                onPressedChanged: canvas.requestPaint()
            }

            onPaint: {
                context.reset();
                context.moveTo(0, 0);
                context.lineTo(width, 0);
                context.lineTo(width / 2, height);
                context.closePath();
                context.fillStyle = "#000000";
                context.fill();
            }
        }

        contentItem: Text {
            height: task_control.height
            leftPadding: 0
            rightPadding: task_control.indicator.width + task_control.spacing
            text: task_control.displayText
            font: task_control.font
            color: "#000000"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: task_control.width
            implicitHeight: task_control.height
            border.color: "#000000"
            border.width: task_control.visualFocus ? task_control.height*6/100 : task_control.height*3/100
            radius: task_control.height*10/100
        }

        popup: Popup {
            y: task_control.height - 1
            width: task_control.width
            implicitHeight: contentItem.implicitHeight
            padding: task_control.height*2/100
            leftPadding: width*1/100

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: task_control.popup.visible ? task_control.delegateModel : null
                currentIndex: task_control.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                border.color: "#000000"
                radius: task_control.height*10/100
            }
        }
    }

    Label {
        id: explain_label
        y: parent.height*17.5/100
        width: parent.width*45/100
        height: parent.height*6/100
        text: qsTr("Minutes till auto log off :")
        font.pixelSize: parent.height*3/100
        font.italic: true
        horizontalAlignment: Text.AlignHCenter
        opacity: 0.7
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        font.weight: Font.Bold
        anchors.horizontalCenterOffset: -parent.width*25/100
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label {
        id: netpath_label
        y: parent.height*26.5/100
        width: parent.width*80/100
        height: parent.height*6/100
        text: qsTr("Network Path(ip_address/username/sharedfolder)")
        font.italic: false
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: height*48/100
        opacity: 0.7
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        font.weight: Font.Bold
        anchors.horizontalCenterOffset: -parent.width*6/100
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Rectangle {
        id: netpath_edit
        y: parent.height*32.5/100
        width: parent.width*69/100
        height: parent.height*5/100
        color: "#ffffff"
        border.width: netpath_input.activeFocus ? height*5/100 : height*2.5/100
        border.color: netpath_input.activeFocus ? "#fd8a15" : "#f1f1f1"
        radius: height*13/100
        anchors.horizontalCenterOffset: -parent.width*6/100
        anchors.horizontalCenter: parent.horizontalCenter

        TextInput {
            id: netpath_input
            x: parent.width*4/100
            y: parent.height*21/100
            width: parent.width*96/100
            height: parent.height*80/100
            text: ip_address+"/"+ userName +"/"+sharedFolder
            echoMode: TextInput.Normal
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: parent.height*50/100

        }
    }

    RoundButton {
        id: netpathBt
        y: parent.height*33/100
        width: parent.width*13/100
        height: parent.height*4.5/100
        text: "Clear"
        autoRepeat: false
        font.pixelSize: height*35/100
        anchors.horizontalCenterOffset: parent.width*38/100
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {

            netpath_input.clear()

        }
    }
    Rectangle {
        id: passwd_edit
        y: parent.height*43/100
        width: parent.width*69/100
        height: parent.height*5/100
        color: "#ffffff"
        radius: height*13/100
        border.width: passwd_input.activeFocus ? height*5/100 : height*2.5/100
        border.color: passwd_input.activeFocus ? "#fd8a15" : "#f1f1f1"
        TextInput {
            id: passwd_input
            x: parent.width*4/100
            y: parent.height*15/100
            width: parent.width*84/100
            height: parent.height*85/100
            font.pixelSize: parent.height*50/100
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            echoMode: TextInput.Password
            text: password
        }
        Button {
            id: hidebutton
            property bool isShow: false
            x: parent.width*88/100
            y: 0
            width: parent.width*12/100
            height: parent.height
            text: qsTr("")
            background: Image {
                id: icon
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter
                visible: true
                fillMode: Image.Stretch
                source: "assets/hide.png"
            }
            onClicked: {
                isShow = !isShow
                if(isShow)
                {
                    passwd_input.echoMode = TextInput.Normal
                    icon.source = "assets/unhide.png"

                }
                else
                {
                    passwd_input.echoMode = TextInput.Password
                    icon.source = "assets/hide.png"
                }

            }

        }
        anchors.horizontalCenterOffset: -parent.width*6/100
        anchors.horizontalCenter: parent.horizontalCenter
    }

    RoundButton {
        id: passwdBt
        y: parent.height*43.5/100
        width: parent.width*13/100
        height: parent.height*4.5/100
        text: "Clear"
        autoRepeat: false
        font.pixelSize: height*35/100
        anchors.horizontalCenterOffset: parent.width*38/100
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {

            passwd_input.clear()

        }
    }

    Label {
        id: passwd_label
        y:  parent.height*39/100
        width: parent.width*13/100
        height: parent.height*6/100
        text: qsTr("Password")
        font.italic: false
        font.pixelSize: height*48/100
        horizontalAlignment: Text.AlignHCenter
        opacity: 0.7
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        font.weight: Font.Bold
        anchors.horizontalCenterOffset: -parent.width*39.5/100
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
    }
    MessageDialog {

        id: confirmMsg
        visible: false
        title: "Input Error"
        text: "Input all value correctly !"
        modality:  Qt.WindowModal // Qt.NonModal
        icon : StandardIcon.Warning
        onAccepted: {

            confirmMsg.close()

        }

    }
    RoundButton {
        id: saveBt
        y: parent.height*67.5/100
        width: parent.width*25/100
        height: parent.height*7/100
        text: "Save"
        font.capitalization: Font.Capitalize
        autoRepeat: false
        font.pixelSize: height*39/100
        anchors.horizontalCenterOffset: -parent.width*34/100
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {

            if(netpath_input.text.split('/').length > 2 && passwd_input.text.length > 0)
             {

                custom_user.serverInfoFileSave("server.txt",netpath_input.text,passwd_input.text)
                custom_user.logoffTimeInfoFileSave("time.txt",task_control.currentIndex==9 ? 0 : task_control.currentIndex*5 + 5)
             }
            else
             {
                    confirmMsg.open()
             }
        }
    }

    RoundButton {
        id: menuBt
        y: parent.height*67.5/100
        width: parent.width*25/100
        height: parent.height*7/100
        text: "Menu"
        autoRepeat: false
        font.pixelSize: height*39/100
        font.capitalization: Font.Capitalize
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {

            advanced_page.signalExit()
        }

    }

    RoundButton {
        id: exitBt
        y: parent.height*67.5/100
        width: parent.width*25/100
        height: parent.height*7/100
        text: "Exit"
        autoRepeat: false
        font.pixelSize: height*39/100
        font.capitalization: Font.Capitalize
        anchors.horizontalCenterOffset: parent.width*34/100
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: Qt.quit()
    }

}
