
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3

ApplicationWindow {

    id: main_window
    width: 432
    height: 768
    visible: true
    visibility: "FullScreen"
    title: qsTr("MainWindow")

    property string ip_address: ""
    property string userName: ""
    property string sharedFolder: ""
    property string password: ""
    property string outText: ""

    property int logoffTime: 5
    property bool permission: false

    function androidBatteryStateChanged(level, onCharge)
    {

        _option_page.androidBatteryStateChanged(level, onCharge)

    }
    function androidSystemInformation(body)
    {
        _option_page.androidSystemInformation(body)

    }
    function downloadFile(usrname, pass, ip_address, filePath,outStream)
    {
       return custom_user.downloadFile(usrname, pass, ip_address, filePath,outStream)
    }
    function initSever()
    {
       custom_user.getServerModel()
       ip_address= custom_user.serverAddress
       userName= custom_user.serverUserName
       sharedFolder= custom_user.sharedFolderName
       switch(task_control.currentIndex)
        {
          case 2:
                sharedFolder +="/consumptask_"+Qt.formatDateTime(new Date(), "yy_MM_dd_hh_mm_ss")+".csv"
                outText=table_model.getCSVData()
            break
          case 1:
               sharedFolder +="/inventorytask_"+Qt.formatDateTime(new Date(), "yy_MM_dd_hh_mm_ss")+".csv"
               outText=inventoryTable_model.getCSVData()
            break
          case 0:
               sharedFolder +="/shippingtask_"+Qt.formatDateTime(new Date(), "yy_MM_dd_hh_mm_ss")+".csv"
               outText=shippingTable_model.getCSVData()
            break


        }
       password= custom_user.serverPassword

    }
    function getAutoLogoffTime()
    {
        custom_user.sysLogoffTime(logoffTime)
    }
    function confirmMessageDlg(title,content)
    {
       inputMessage.title = title
       inputMessage.text = content
       inputMessage.open()

    }
    function deleteTaskData()
    {
        switch(task_control.currentIndex)
         {
           case 2:
                table_model.deleteAllData()
             break
           case 1:
                inventoryTable_model.deleteAllData()
             break
           case 0:
                shippingTable_model.deleteAllData()
             break


         }

    }
    Page {
        id: mainmenu_page
        width: parent.width
        height: parent.height
        visible: true
        Component.onCompleted: {

            busy_indicator.running=false
            messageDialog.open()
            initSever()
            logoffTime=custom_user.logoffTime
            getAutoLogoffTime()

        }

        MessageDialog {

            id: messageDialog
            title: "Database error!"
            text: db_model.dbState
            modality:  Qt.WindowModal // Qt.NonModal
            icon : StandardIcon.Warning
            onAccepted: {
                Qt.quit()
            }
            Component.onCompleted:{

                if(text == "ok")
                   visible = false
                else
                   visible = true
            }
        }
        MessageDialog {

            id: serverMessage
            title: "Server error!"
            visible: false
            text: "Please Add Server !"
            modality:  Qt.WindowModal // Qt.NonModal
            icon : StandardIcon.Warning
            onAccepted: {
                serverMessage.close()
            }

        }
        MessageDialog {

            id: downloadMessage
            title: "Download error!"
            visible: false
            text: "Download fail. Please check SMB connect !"
            modality:  Qt.WindowModal // Qt.NonModal
            icon : StandardIcon.Warning
            onAccepted: {
                downloadMessage.close()
            }

        }
        MessageDialog {

            id: confirmMsg
            visible: false
            title: "Confirm Download"
            text: "Would you really download now?"
            modality:  Qt.WindowModal // Qt.NonModal
            icon : StandardIcon.Question
            standardButtons: StandardButton.Ok | StandardButton.Cancel
            onAccepted: {

               initSever()
               if(ip_address.length >0)
                {
                   if(downloadFile(userName,password,ip_address,sharedFolder,outText) === false)
                   {
                        downloadMessage.open()
                   }
                }
               else
                  serverMessage.open()
                confirmMsg.close()

            }
            onRejected: {

                confirmMsg.close()
            }

        }
        MessageDialog {

            id: inputMessage
            title: ""
            visible: false
            text: ""
            modality:  Qt.WindowModal // Qt.NonModal
            icon : StandardIcon.Warning
            onAccepted: {
                inputMessage.close()
            }

        }
        MessageDialog {

            id: taskDelMsg
            visible: false
            title: "Confirm Delete"
            text: "Would you really delete all data of task?"
            modality:  Qt.WindowModal // Qt.NonModal
            icon : StandardIcon.Question
            standardButtons: StandardButton.Ok | StandardButton.Cancel
            onAccepted: {

                deleteTaskData()
                taskDelMsg.close()

            }
            onRejected: {

                taskDelMsg.close()
            }

        }

        Image {
            id: image
            anchors.fill: parent
            source: "assets/mainmenu.jpg"
            fillMode: Image.Stretch
            opacity: 0.3

            Label {
                id: task_label
                x: parent.width*97/100
                y: parent.height*37/100
                width: parent.width*46/100
                height: parent.height*6/100
                text: qsTr("Tasks")
                font.pixelSize: height*52/100
                font.bold: true
                anchors.horizontalCenterOffset: 0
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        BusyIndicator {
            id: busy_indicator
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            running: true

            contentItem: Item {
                id: element
                implicitWidth: mainmenu_page.width*15/100
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
            text: qsTr("Operator,  please Log on")
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

        Button {
            id: login_button
            y: parent.height*24/100
            width: parent.width*80/100
            height: parent.height*8/100
            text: qsTr("")
            font.capitalization: Font.Capitalize
            wheelEnabled: false
            autoExclusive: false
            checked: false
            checkable: false
            highlighted: false
            flat: false
            autoRepeat: false
            focusPolicy: Qt.StrongFocus
            hoverEnabled: true
            font.pixelSize: height*53/100
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter

            contentItem: Text {
                anchors.horizontalCenter: parent.horizontalCenter
                font: login_button.font
                opacity: enabled ? 1.0 : 0.3
                color: login_button.down ? "#17a81a" : "#21be2b"
                text: "Login"
                fontSizeMode: Text.Fit
                textFormat: Text.AutoText
                antialiasing: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: parent.width*29/100
                implicitHeight: parent.height*70/100
                opacity: enabled ? 1 : 0.3
                border.color: login_button.down ? "#17a81a" : "#21be2b"
                border.width: implicitHeight*3/100
                radius: implicitHeight/2
            }
            onClicked: {

                _login_page.visible = true
                mainmenu_page.visible = false

            }

        }
        Button {
            id: download_button
            y: parent.height*59/100
            width: parent.width*32/100
            height: parent.height*16/100
            text: qsTr("")
            enabled: false
            font.capitalization: Font.Capitalize
            anchors.horizontalCenterOffset: -width*73/100
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.7
            font.pixelSize: height*16/100
            font.bold: true

            contentItem: Text {
                anchors.horizontalCenter: parent.horizontalCenter
                font: download_button.font
                opacity: enabled ? 1.0 : 0.3
                color: download_button.down ? "#17a81a" : "#21be2b"
                text: "Download"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: parent.width*36/100
                implicitHeight: parent.height*16/100
                opacity: enabled ? 1 : 0.3
                border.color: download_button.down ? "#17a81a" : "#21be2b"
                border.width: implicitHeight*1.5/100
                radius: implicitHeight*40/100
            }
            onClicked:
            {
               confirmMsg.open()
            }
        }
        ComboBox {
            id: task_control
            y: parent.height*44/100
            width: parent.width*61/100
            height: parent.height*8/100
            enabled: false
            editable: false
            anchors.horizontalCenterOffset: 0
            font.pixelSize: height*37/100
            leftPadding: width*7/100
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            model: ["Shipping", "Inventory", "Consumption"]

            delegate: ItemDelegate {
                width: task_control.width
                contentItem: Text {
                    text: modelData
                    color: "#21be2b"
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
                    context.fillStyle = task_control.pressed ? "#17a81a" : "#21be2b";
                    context.fill();
                }
            }

            contentItem: Text {
                height: task_control.height
                leftPadding: 0
                rightPadding: task_control.indicator.width + task_control.spacing
                text: task_control.displayText
                font: task_control.font
                color: task_control.pressed ? "#17a81a" : "#21be2b"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: task_control.width
                implicitHeight: task_control.height
                border.color: task_control.pressed ? "#17a81a" : "#21be2b"
                border.width: task_control.visualFocus ? task_control.height*6/100 : task_control.height*3/100
                radius: task_control.height*20/100
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
                    border.color: "#21be2b"
                    radius: task_control.height*10/100
                }
            }
        }

        Button {
            id: scan_button
            y: parent.height*59/100
            width: parent.width*32/100
            height: parent.height*16/100
            text: qsTr("")
            enabled: false
            font.capitalization: Font.Capitalize
            anchors.horizontalCenterOffset: width*73/100
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.7
            font.pixelSize: height*16/100
            background: Rectangle {
                implicitWidth: parent.width*36/100
                opacity: enabled ? 1 : 0.3
                border.color: scan_button.down ? "#17a81a" : "#21be2b"
                border.width: implicitHeight*1.5/100
                implicitHeight: parent.height*16/100
                radius: implicitHeight*40/100
            }
            contentItem: Text {
                color: scan_button.down ? "#17a81a" : "#21be2b"
                text: "Scan"
                font: scan_button.font
                opacity: enabled ? 1.0 : 0.3
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
            }
            font.bold: true

            onClicked: {

                switch(task_control.currentIndex)
                {
                  case 2:

                      _consumptaskmenu_page.tasklistLoad(_login_page.number)
                      _consumptaskmenu_page.visible = true
                      mainmenu_page.visible = false
                    break
                  case 1:

                      _inventorytaskmenu_page.tasklistLoad(_login_page.number)
                      _inventorytaskmenu_page.visible = true
                      mainmenu_page.visible = false
                    break
                  case 0:
                      _shippingtaskmenu_page.tasklistLoad(_login_page.number)
                      _shippingtaskmenu_page.visible = true
                      mainmenu_page.visible = false
                    break


                }

            }

        }

        Button {
            id: purge_button
            y: parent.height*80/100
            width: parent.width*32/100
            height: parent.height*16/100
            text: qsTr("")
            enabled: false
            font.capitalization: Font.Capitalize
            anchors.horizontalCenterOffset: -width*73/100
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.7
            font.pixelSize: height*16/100
            background: Rectangle {
                implicitWidth: parent.width*36/100
                opacity: enabled ? 1 : 0.3
                border.color: purge_button.down ? "#17a81a" : "#21be2b"
                border.width: implicitHeight*1.5/100
                implicitHeight: parent.height*16/100
                radius: implicitHeight*40/100
            }
            contentItem: Text {
                color: purge_button.down ? "#17a81a" : "#21be2b"
                text: "Purge"
                font: purge_button.font
                opacity: enabled ? 1.0 : 0.3
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
            }
            font.bold: true
            onClicked: {
                taskDelMsg.open()
            }

        }

        Button {
            id: options_button
            y: parent.height*80/100
            width: parent.width*32/100
            height: parent.height*16/100
            text: qsTr("")
            enabled: false
            font.capitalization: Font.Capitalize
            anchors.horizontalCenterOffset: width*73/100
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.7
            font.pixelSize: height*16/100
            background: Rectangle {
                implicitWidth: parent.width*36/100
                opacity: enabled ? 1 : 0.3
                border.color: options_button.down ? "#17a81a" : "#21be2b"
                border.width: implicitHeight*1.5/100
                implicitHeight: parent.height*16/100
                radius: implicitHeight*40/100
            }
            contentItem: Text {
                color: options_button.down ? "#17a81a" : "#21be2b"
                text: "Options"
                opacity: enabled ? 1.0 : 0.3
                font: options_button.font
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
            }
            font.bold: true
            onClicked: {

                _option_page.ip_address = ip_address
                _option_page.userName = userName
                _option_page.sharedFolder = custom_user.sharedFolderName
                _option_page.password = password
                _option_page.logoffTime = logoffTime
                _option_page.pageShow()
                _option_page.visible = true
                mainmenu_page.visible = false

            }


        }
    }

    Login {

        id: _login_page
        title: qsTr("Login_Page ")

        onSignalExit:
        {
            _login_page.visible = false     // Close the first window
            if(_login_page.loginable)
            {
                 permission = _login_page.permission
                 task_control.enabled = true

                 purge_button.enabled=false
                 options_button.enabled=false
                 scan_button.enabled=false
                 download_button.enabled=false

                 _consumptaskmenu_page.isCreat = false
                 _consumptaskmenu_page.isEdit = false
                 _consumptaskmenu_page.isDelete = false

                _inventorytaskmenu_page.isCreat = false
                _inventorytaskmenu_page.isEdit = false
                _inventorytaskmenu_page.isDelete = false

                _shippingtaskmenu_page.isCreat = false
                _shippingtaskmenu_page.isEdit = false
                _shippingtaskmenu_page.isDelete = false


                 if((permission >> 6) & 0x1)
                 {
                    _consumptaskmenu_page.isCreat = true
                    _inventorytaskmenu_page.isCreat = true
                    _shippingtaskmenu_page.isCreat = true

                 }
                 if((permission >> 5) & 0x1)
                 {
                     _consumptaskmenu_page.isEdit = true
                     _inventorytaskmenu_page.isEdit = true
                     _shippingtaskmenu_page.isEdit = true
                 }
                 if((permission >> 4) & 0x1)
                 {
                     _consumptaskmenu_page.isDelete = true
                     _inventorytaskmenu_page.isDelete = true
                     _shippingtaskmenu_page.isDelete = true
                 }
                 if((permission >> 3) & 0x1)
                 {
                    options_button.enabled=true
                 }
                 if((permission >> 2) & 0x1)
                 {
                     download_button.enabled=true
                 }
                 if((permission >> 1) & 0x1)
                 {
                     purge_button.enabled=true
                 }
                 if((permission) & 0x1)
                 {
                    scan_button.enabled=true
                 }




            }
            mainmenu_page.visible = true      // Shows the main window
        }
    }

    Options {

        id: _option_page

        onSignalExit:
        {
            _option_page.visible = false     // Close the first window
            mainmenu_page.visible = true      // Shows the main window
            logoffTime=custom_user.logoffTime
            getAutoLogoffTime()
        }

    }

    ConsumpTaskMenu {

        id: _consumptaskmenu_page
        title: qsTr("TaskMenu_Page ")


        onSignalExit:
        {
            _consumptaskmenu_page.visible = false     // Close the first window
            mainmenu_page.visible = true       // Shows the main window
        }
    }
    InventoryTaskMenu {

        id: _inventorytaskmenu_page
        title: qsTr("TaskMenu_Page ")


        onSignalExit:
        {
            _inventorytaskmenu_page.visible = false     // Close the first window
            mainmenu_page.visible = true       // Shows the main window
        }
    }
    ShippingTaskMenu {

        id: _shippingtaskmenu_page
        title: qsTr("TaskMenu_Page ")


        onSignalExit:
        {
            _shippingtaskmenu_page.visible = false     // Close the first window
            mainmenu_page.visible = true       // Shows the main window
        }
    }



}

