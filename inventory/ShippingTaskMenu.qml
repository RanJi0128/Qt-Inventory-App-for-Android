import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3

Page {

    id:taskmenu_page
    signal signalExit
    visible: false
//    width: 432
//    height: 768
    width: Screen.width
    height: Screen.height
    property int userId: 0
    property bool isCreat: false
    property bool isEdit: false
    property bool isDelete: false

    function tasklistLoad(key)
    {
       userId = key
       shippingTable_model.getReadAllData(key)
       _loader.reload()

    }
    Page {

            id: menutask_page
            signal signalExit
            visible: true
            width: parent.width
            height: parent.height


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
                    implicitWidth: menutask_page.width*15/100
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
                text: qsTr("Shipping Jobs/Units")
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

            Rectangle {
                id: rectangle
                y: parent.height*14/100
                height: parent.height*70/100
                color: "#ffffff"
                radius: 0
                border.width: parent.width*0.5/100
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                Rectangle {
                    id: line
                    y: rectangle.height*9/100
                    height: rectangle.border.width
                    color: "#000000"
                    anchors.left: parent.left
                    anchors.leftMargin: rectangle.border.width
                    anchors.right: parent.right
                    anchors.rightMargin: rectangle.border.width
                }

                Label {
                    id: tag
                    y: rectangle.border.width
                    width: rectangle.width*38/100
                    height: rectangle.height*9/100
                    text: qsTr("Tags")
                    anchors.horizontalCenterOffset: -rectangle.width*30/100
                    anchors.horizontalCenter: parent.horizontalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.weight: Font.Bold
                    font.pixelSize: height*45/100
                }

                Label {
                    id: order
                    y: rectangle.border.width
                    width: rectangle.width*60/100
                    height: rectangle.height*9/100
                    text: qsTr("OrderNumber")
                    anchors.horizontalCenterOffset: rectangle.width*20/100
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.weight: Font.Bold
                    font.pixelSize: height*45/100
                }
                Loader {
                        id: _loader

                        function reload() {
                            source = "";
                            $QmlEngine.clearCache();
                            source = "ShippingTaskView.qml";
                        }
                        anchors.fill: parent
                        anchors.margins: rectangle.border.width
                        anchors.topMargin: rectangle.height*9/100+line.height
                        source: "ShippingTaskView.qml"

                    }

                Connections {
                       target: _loader.item
                       onRowSelected :{
                           editBt.enabled=isEdit & true
                           deleteBt.enabled=isDelete & true

                       }


                }
                Gradient {
                    id: clubcolors
                    GradientStop { position: 0.0; color: "#8EE2FE"}
                    GradientStop { position: 0.66; color: "#7ED2EE"}
                }

            }

            RoundButton {
                id: menuBt
                y: parent.height*88/100
                width: parent.width*19/100
                height: parent.height*6/100
                text: "Menu"
                font.pixelSize: height*39/100
                font.bold: true
                autoRepeat: false
                anchors.horizontalCenterOffset: -parent.width*40/100
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {

                    taskmenu_page.signalExit()

                }
            }
            MessageDialog {

                id: deleteMessage
                title: "Delete Confirm"
                visible: false
                text: "Do you delete really ?"
                modality:  Qt.WindowModal // Qt.NonModal
                icon : StandardIcon.Question
                standardButtons: StandardButton.Ok | StandardButton.Cancel
                onAccepted: {
                    var pri_key = shippingTable_model.getData(_loader.item.rowNum,0)
                    if(shippingTable_model.deleteData(pri_key))
                    {
                        editBt.enabled=false
                        deleteBt.enabled=false
                        tasklistLoad(userId)
                    }
                    deleteMessage.close()
                }
                onRejected: {

                    deleteMessage.close()
                }


            }
            RoundButton {
                id: deleteBt
                y: menuBt.y
                width: parent.width*16/100
                height: menuBt.height
                text: "Del"
                enabled: false
                autoRepeat: false
                anchors.horizontalCenterOffset: -parent.width*21.5/100
                font.pixelSize: menuBt.font.pixelSize
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    deleteMessage.open()
                }
            }

            RoundButton {
                id: editBt
                y: menuBt.y
                width: parent.width*17/100
                height: menuBt.height
                text: "Edit"
                enabled: false
                autoRepeat: false
                anchors.horizontalCenterOffset: -parent.width*5.5/100
                font.bold: true
                font.pixelSize: menuBt.font.pixelSize
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {

                    _shippingtaskcreate_page.userId = userId
                    _shippingtaskcreate_page.edit_fl=true
                    _shippingtaskcreate_page.rowNum = _loader.item.rowNum
                    _shippingtaskcreate_page.visible = true
                    menutask_page.visible = false

                }
            }

            RoundButton {
                id: scanBt
                y: menuBt.y
                width: parent.width*19/100
                height: menuBt.height
                text: "Scan"
                autoRepeat: false
                anchors.horizontalCenterOffset: parent.width*12.5/100
                font.pixelSize: menuBt.font.pixelSize
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            RoundButton {
                id: createBt
                y: menuBt.y
                width: parent.width*24/100
                height: menuBt.height
                text: "Create"
                enabled: isCreat
                autoRepeat: false
                anchors.horizontalCenterOffset: parent.width*34.5/100
                font.bold: true
                font.pixelSize: menuBt.font.pixelSize
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {

                    _shippingtaskcreate_page.userId = userId
                    _shippingtaskcreate_page.edit_fl=false
                    _shippingtaskcreate_page.visible = true
                    menutask_page.visible = false

                }
            }
    }
    ShippingCreateTask {

        id: _shippingtaskcreate_page
        title: qsTr("TaskCreate_Page ")
        visible: false
        onSignalExit:{

            editBt.enabled=false
            deleteBt.enabled=false
            taskmenu_page.tasklistLoad(userId)
            _shippingtaskcreate_page.visible = false
            menutask_page.visible = true

        }
    }

}
