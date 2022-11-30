
import 'package:entrance/main.dart';
import 'package:flutter/material.dart';

enum ButtonType { Text, Elevated, Outlined, Floating, FloatingExtended, Menu }

class AppButton extends StatelessWidget {
  //variable
  final String text;

  //to define the type of buttons
  final ButtonType type;

  final IconData icon;

  //methods
  final Function() onPressed;

  var checked = false;

  //constructor
  AppButton(
      {required this.type,
      required this.text,
      required this.onPressed,
      required this.icon,
      required this.checked});

  @override
  Widget build(BuildContext context) {
    switch (type) {

      //normal text button with and without icon
      case ButtonType.Text:
        {
          if (icon == null) {
            return TextButton(
              child: Text(
                text.toUpperCase(),
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: onPressed,
            );
          } else {
            return TextButton.icon(
              icon: Icon(
                icon,
                size: 16,
                color: primaryColor,
              ),
              label: Text(
                text.toUpperCase(),
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: onPressed,
            );
          }
        }
        break;
      case ButtonType.Elevated:
        {
          if (icon == null) {
            return ElevatedButton(
                child: Text(
                  text.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: onPressed,
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor)));
          } else {
            return ElevatedButton.icon(
              icon: Icon(
                icon,
                size: 16,
                color: Colors.white,
              ),
              label: Text(text.toUpperCase(),
                  style: TextStyle(color: Colors.white)),
              onPressed: onPressed,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor)),
            );
          }
        }
        break;
      case ButtonType.Outlined:
        {
          if (icon == null) {
            return OutlinedButton(
              child: Text(
                text.toUpperCase(),
                style: TextStyle(color: primaryColor),
              ),
              onPressed: onPressed,
            );
          } else {
            return OutlinedButton.icon(
              icon: Icon(
                icon,
                size: 16,
                color: primaryColor,
              ),
              label: Text(text.toUpperCase(),
                  style: TextStyle(color: primaryColor)),
              onPressed: onPressed,
            );
          }
        }

        break;
      case ButtonType.Floating:
        {
          return FloatingActionButton(
            tooltip: text,
            child: Icon(icon),
            onPressed: onPressed,
          );
        }
        break;

      case ButtonType.FloatingExtended:
        {
          return FloatingActionButton.extended(
            icon: new Icon(
              icon,
              size: 16,
              color: Colors.white,
            ),
            label:
                Text(text.toUpperCase(), style: TextStyle(color: Colors.white)),
            onPressed: onPressed,
          );
        }
        break;

      case ButtonType.Menu:
        {
          if (icon == null) {
            return ElevatedButton(
                child: Text(
                  text.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: onPressed,
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor)));
          } else {
            var color = Colors.transparent;

            if (checked == true) {
              color = primaryColor;
            }

            Widget widget = SizedBox();

            widget = Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text.toUpperCase(),
                style: TextStyle(color: checked ? Colors.white : Colors.grey),
              ),
            );

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                overlayColor: MaterialStateProperty.all<Color>(primaryColor),
                onTap: onPressed,
                child: Container(
                  color: color,
                  child: Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            size: 24,
                            color: checked ? Colors.white : Colors.grey,
                          ),
                          widget
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );

            return ElevatedButton.icon(
              icon: Icon(
                icon,
                size: 16,
                color: Colors.white,
              ),
              label: Text("", style: TextStyle(color: Colors.white)),
              onPressed: onPressed,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor)),
            );
          }
        }
        break;

      default:
        {
          return new MaterialButton(
              child: Text(text, style: Theme.of(context).textTheme.button),
              onPressed: onPressed);
        }

        break;
    }
  }
}
