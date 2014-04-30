import QtQuick 2.0
import Sailfish.Silica 1.0
import "CeCILL_en.js" as License_en
import "CeCILL.js" as License

Page {
    id:licensePage
    property bool isEn : false;

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            height: header.height + label.implicitHeight

            PageHeader {
                id: header
                title: qsTr("License")
            }

            Label {
                id: label

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.rightMargin: Theme.paddingMedium
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.pixelSize: Theme.fontSizeExtraSmall
                text: licensePage.isEn ? License_en.license : License.license
            }

        }

        ScrollDecorator { }
    }
}
