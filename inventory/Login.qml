
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3

Page {

    id:login_page
    signal signalExit
    property bool loginable: false
    property int  number : 0
    property int  permission : 0
    visible: false
//    width: 432
//    height: 768
    width: Screen.width
    height: Screen.height
    Component.onCompleted: {

        busy_indicator.running=false

    }

    Image {
        id: image
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        visible: true
        fillMode: Image.Stretch
        source: "assets/login.png"
    }

    BusyIndicator {
        id: busy_indicator
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        running: true

        contentItem: Item {
            id: element
            implicitWidth: login_page.width*15/100
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
    Label {
        id: title_label
        y: parent.height*11/100
        width: parent.width
        height: parent.height*6/100
        text: qsTr("Login")
        opacity: 0.7
        font.pixelSize: height*70/100
        anchors.horizontalCenterOffset: 0
        fontSizeMode: Text.Fit
        font.weight: Font.Bold
        font.italic: true
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label {
        id: username
        y: parent.height*23.5/100
        width: parent.width*28/100
        height: parent.height*5.5/100
        color: "#14428b"
        text: qsTr("Operator Name")
        anchors.horizontalCenterOffset: -parent.width*27/100
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        font.pixelSize: height*50/100
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
    ComboBox {
        id: user_control
        y: parent.height*23.5/100
        width: parent.width*50/100
        height: parent.height*6/100
        focusPolicy: Qt.WheelFocus
        anchors.horizontalCenterOffset: parent.width*15/100
        font.pixelSize: height*40/100
        leftPadding: width*5/100
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        model: login_model.nameModel
        delegate: ItemDelegate {
            width: user_control.width
            contentItem: Text {
                text: modelData
                color: "#000000"
                font: user_control.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            highlighted: user_control.highlightedIndex === index
        }

        indicator: Canvas {
            id: canvas
            x: user_control.width - width - user_control.rightPadding
            y: user_control.topPadding + (user_control.availableHeight - height) / 2
            width: user_control.width*6/100
            height: user_control.height*18/100
            contextType: "2d"

            Connections {
                target: user_control
                onPressedChanged: canvas.requestPaint()
            }

            onPaint: {
                context.reset();
                context.moveTo(0, 0);
                context.lineTo(width, 0);
                context.lineTo(width / 2, height);
                context.closePath();
                context.fillStyle = user_control.pressed ? "#fd8a15" : "#000000";
                context.fill();
            }
        }

        contentItem: Text {
            leftPadding: 0
            rightPadding: user_control.indicator.width + user_control.spacing
            text: user_control.displayText
            anchors.horizontalCenter: parent.horizontalCenter
            font: user_control.font
            color: user_control.pressed ? "#fd8a15" : "#000000"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: width
            implicitHeight: height
            border.color: user_control.pressed ? "#fd8a15" : "#f1f1f1"
            border.width: user_control.visualFocus ? user_control.height*5/100 : user_control.height*2.5/100
            radius: user_control.height*13/100
        }

        popup: Popup {
            y: user_control.height*98/100
            width: user_control.width
            implicitHeight: contentItem.implicitHeight
            padding: user_control.height*2.5/100
            leftPadding: width*5/100
            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: user_control.popup.visible ? user_control.delegateModel : null
                currentIndex: user_control.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                border.color: "#ffffff"
                radius: user_control.height*2.5/100
            }
        }
    }

    Label {
        id: password
        y: parent.height*32/100
        width: parent.width*29/100
        height: parent.height*5.5/100
        color: "#14428b"
        text: qsTr("Password")
        anchors.horizontalCenterOffset: -parent.width*27/100
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        font.pixelSize: height*50/100
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }


    Rectangle {
        id: rectangle
        y: parent.height*32/100
        width: parent.width*50/100
        height: parent.height*5.5/100
        color: "#ffffff"
        border.width: password_input.activeFocus ? height*5/100 : height*2.5/100
        border.color: password_input.activeFocus ? "#fd8a15" : "#f1f1f1"
        radius: height*13/100
        anchors.horizontalCenterOffset: parent.width*15/100
        anchors.horizontalCenter: parent.horizontalCenter

        TextInput {
            id: password_input
            x: parent.width*4/100
            y: parent.height*21/100
            width: parent.width*82/100
            height: parent.height*79/100
            echoMode: TextInput.Password
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: parent.height*50/100
            Component.onCompleted: password_input.ensureVisible(0)

        }

        Button {
            id: hidebutton
            property bool isShow: false
            x: parent.width*86/100
            y: 0
            width: parent.width*14/100
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
                    password_input.echoMode = TextInput.Normal
                    icon.source = "assets/unhide.png"

                }
                else
                {
                    password_input.echoMode = TextInput.Password
                    icon.source = "assets/hide.png"
                }

            }

        }
    }
    Label {
        id: explain_label
        y:  parent.height*48/100
        width:  parent.width*85/100
        height: parent.height*11/100
        text: qsTr("Select an Operator from list.To enter the password. Click ok and start using program.")
        opacity: 0.7
        wrapMode: Text.WordWrap
        font.pixelSize: height*40/100
        anchors.horizontalCenterOffset: 0
        fontSizeMode: Text.Fit
        font.weight: Font.Bold
        font.italic: true
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Button {
        id: ok_button
        y: parent.height*77/100
        width: parent.width*27/100
        height: parent.height*7/100
        font.capitalization: Font.AllUppercase
        font.pixelSize: height*38/100
        anchors.horizontalCenterOffset: -parent.width*21/100
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter

        contentItem: Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font: ok_button.font
            opacity: enabled ? 1.0 : 0.3
            color: "#14428b"
            text: "Ok"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: width
            implicitHeight: height
            opacity: enabled ? 1 : 0.3
            border.width: ok_button.pressed ? height*5/100 : height*2.5/100
            color: ok_button.pressed ? "#8fd7f1" : "#e3edfb"
            border.color: ok_button.pressed ? "#8fd7f1" : "#e3edfb"
            radius: height*22/100
        }
        onClicked: {

              var match = login_model.confirmUser(user_control.displayText,password_input.text,user_control.currentIndex)
              password_input.clear()
              if(!match[0])
              {
                    messageDialog.text = "Password Wrong!"
                    messageDialog.visible = true
              }
              else
              {
                    number = match[0]
                    permission = match[1]
                    loginable=true
                    login_page.signalExit()
              }


        }

    }

    Button {
        id: cancel_button
        y: parent.height*77/100
        width: parent.width*27/100
        height: parent.height*7/100
        anchors.horizontalCenterOffset: parent.width*21/100
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: height*38/100
        font.bold: true
        contentItem: Text {
            color: "#14428b"
            text: "Cancel"
            verticalAlignment: Text.AlignVCenter
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            anchors.horizontalCenter: parent.horizontalCenter
            font: cancel_button.font
            horizontalAlignment: Text.AlignHCenter
        }

        background: Rectangle {
            radius: height*22/100
            border.width: cancel_button.pressed ? height*5/100 : height*2.5/100
            color: cancel_button.pressed ? "#8fd7f1" : "#e3edfb"
            border.color: cancel_button.pressed ? "#8fd7f1" : "#e3edfb"
            implicitWidth: width
            opacity: enabled ? 1 : 0.3
            implicitHeight: height

        }
        onClicked: {
            password_input.clear()
            loginable=false
            login_page.signalExit()

        }
    }
    MessageDialog {

        id: messageDialog
        visible: false
        title: "Input error!"
        modality:  Qt.WindowModal // Qt.NonModal
        icon : StandardIcon.Warning
        onAccepted: {
            visible = false
        }

    }
}



