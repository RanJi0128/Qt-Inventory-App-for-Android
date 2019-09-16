import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Page {

        id:taskcreate_page
        visible: true
    //    width: 432
    //    height: 768
        signal signalExit
          width: Screen.width
          height: Screen.height

         property int userId: 0
         property int rowNum: -1
         property bool edit_fl: false

        Component.onCompleted: {

            busy_indicator.running=false
        }

        Image {
            id: image
            anchors.fill: parent
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
                implicitWidth: taskcreate_page.width*15/100
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
            y: parent.height*8/100
            width: parent.width
            height: parent.height*6/100
            text: qsTr("Inventory Create/Edit")
            font.pixelSize: height*50/100
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
            id: physical_label
            y: parent.height*25.5/100
            width: parent.width*29/100
            height: parent.height*4/100
            color: "#14428b"
            text: qsTr("Physical Count")
            font.pixelSize: height*55/100
            anchors.horizontalCenterOffset: -parent.width*26/100
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }


        Rectangle {
            id: physical_edit
            y: parent.height*30/100
            width: parent.width*69/100
            height: parent.height*5.5/100
            color: "#ffffff"
            border.width: physical_input.activeFocus ? height*5/100 : height*2.5/100
            border.color: physical_input.activeFocus ? "#fd8a15" : "#f1f1f1"
            radius: height*13/100
            anchors.horizontalCenterOffset: -parent.width*4.5/100
            anchors.horizontalCenter: parent.horizontalCenter

            TextInput {
                id: physical_input
                x: parent.width*4/100
                y: parent.height*21/100
                width: parent.width*96/100
                height: parent.height*79/100
                echoMode: TextInput.Normal
                text: rowNum > -1 ? inventoryTable_model.getData(rowNum,2): ""
                validator: RegExpValidator{regExp: /^[1-9][0-9]*$/}
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: parent.height*50/100

            }
        }
        RoundButton {
            id: physicalBt
            y: parent.height*30.5/100
            width: parent.width*13/100
            height: parent.height*4.5/100
            text: "Clear"
            anchors.horizontalCenterOffset: parent.width*40/100
            font.pixelSize: height*30/100
            font.bold: true
            autoRepeat: false
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {

                physical_input.clear()

            }

        }

        Label {
            id: location_label
            y: parent.height*36.5/100
            width: parent.width*29/100
            height: parent.height*4/100
            color: "#14428b"
            text: qsTr("Location")
            anchors.horizontalCenterOffset: -parent.width*31/100
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pixelSize: height*55/100
            horizontalAlignment: Text.AlignHCenter
            fontSizeMode: Text.Fit
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            id: location_edit
            y: parent.height*41.5/100
            width: parent.width*69/100
            height: parent.height*5.5/100
            color: "#ffffff"
            radius: height*13/100
            TextInput {
                id: location_input
                x: parent.width*4/100
                y: parent.height*21/100
                width: parent.width*96/100
                height: parent.height*79/100
                font.pixelSize: parent.height*50/100
                echoMode: TextInput.Normal
                text: rowNum > -1 ? inventoryTable_model.getData(rowNum,3): ""
                validator: RegExpValidator{regExp: /^[a-zA-Z0-9 ]+$/}
                horizontalAlignment: Text.AlignLeft
            }
            anchors.horizontalCenterOffset: -parent.width*4/100
            border.color: location_input.activeFocus ? "#fd8a15" : "#f1f1f1"
            border.width: location_input.activeFocus ? height*5/100 : height*2.5/100
            anchors.horizontalCenter: parent.horizontalCenter
        }

       RoundButton {
            id: locationBt
            y: parent.height*42/100
            width: parent.width*13/100
            height: parent.height*4.5/100
            text: "Clear"
            autoRepeat: false
            anchors.horizontalCenterOffset: parent.width*40/100
            font.pixelSize: height*30/100
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {

                location_input.clear()

            }
        }
        RoundButton {
            id: cancelBt
            y: parent.height*76/100
            width: parent.width*26/100
            height: parent.height*6/100
            text: "Cancel"
            anchors.horizontalCenterOffset: -parent.width*25/100
            autoRepeat: false
            font.bold: true
            font.pixelSize: height*39/100
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {

                taskcreate_page.signalExit()

            }
        }

        RoundButton {
            id: deleteBt
            y: parent.height*76/100
            width: parent.width*26/100
            height: parent.height*6/100
            text: "Delete"
            autoRepeat: false
            visible: false
            anchors.horizontalCenterOffset: 0
            font.pixelSize: cancelBt.font.pixelSize
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        RoundButton {
            id: continueBt
            y: parent.height*76/100
            width: parent.width*30/100
            height: parent.height*6/100
            text: "Continue"
            autoRepeat: false
            anchors.horizontalCenterOffset: parent.width*26.5/100
            font.pixelSize: cancelBt.font.pixelSize
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {

                physical_input.clear()
                location_input.clear()
                sublocation_input.clear()

                if((physical_input.text.length > 0) && (location_input.text.length > 0) && (sublocation_input.text.length > 0))
                {
                     if(!edit_fl){

                         if(inventoryTable_model.insertData(physical_input.text,location_input.text,sublocation_input.text,userId))
                         {
                             taskcreate_page.signalExit()
                         }
                     }
                     else
                     {
                         var pri_key = inventoryTable_model.getData(rowNum,0)
                         if(inventoryTable_model.updateData(physical_input.text,location_input.text,sublocation_input.text,userId,pri_key))
                         {
                             taskcreate_page.signalExit()
                         }
                     }

               }

            }
        }

        RoundButton {
            id: sublocationBt
            y: parent.height*54/100
            width: parent.width*13/100
            height: parent.height*4.5/100
            text: "Clear"
            font.pixelSize: height*30/100
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
            anchors.horizontalCenterOffset: parent.width*40/100
            autoRepeat: false
            onClicked: {

                sublocation_input.clear()

            }
        }

        Label {
            id: sublocation_label
            y: parent.height*48.5/100
            width: parent.width*29/100
            height: parent.height*4/100
            color: "#14428b"
            text: qsTr("Sub_Location")
            font.pixelSize: height*55/100
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            anchors.horizontalCenterOffset: -parent.width*26.4/100
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
        }

        Rectangle {
            id: sublocation_edit
            y: parent.height*53.5/100
            width: parent.width*69/100
            height: parent.height*5.5/100
            color: "#ffffff"
            radius: height*13/100
            border.color: sublocation_input.activeFocus ? "#fd8a15" : "#f1f1f1"
            anchors.horizontalCenter: parent.horizontalCenter
            TextInput {
                id: sublocation_input
                x: parent.width*4/100
                y: parent.height*21/100
                width: parent.width*96/100
                height: parent.height*79/100
                echoMode: TextInput.Normal
                text: rowNum > -1 ? inventoryTable_model.getData(rowNum,4): ""
                validator: RegExpValidator{regExp: /^[a-zA-Z0-9 ]+$/}
                font.pixelSize: parent.height*50/100
                horizontalAlignment: Text.AlignLeft
            }
            anchors.horizontalCenterOffset: -parent.width*4.5/100
            border.width: sublocation_input.activeFocus ? height*5/100 : height*2.5/100
        }

}
