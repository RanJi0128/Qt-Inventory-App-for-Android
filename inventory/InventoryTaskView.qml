import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtQuick.Controls 1.4 as Old


Old.TableView {

        id: tableView
        signal rowSelected
        property int rowNum: -1
        width: Screen.width
        height: Screen.height
        headerVisible: false


        Old.TableViewColumn {
            role: "Tags"
            title: "Tags"
            width: tableView.width*38/100
            horizontalAlignment: Text.AlignHCenter

        }

        Old.TableViewColumn {
            role: "PhysicalCount"
            title: "PhysicalCount"
            width: tableView.width*62/100
            horizontalAlignment: Text.AlignHCenter

        }
        onClicked: {

            rowNum = tableView.currentRow
            tableView.rowSelected()

        }

        model: inventoryTable_model

 }
