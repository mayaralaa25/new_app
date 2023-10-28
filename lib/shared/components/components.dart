import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:toast/toast.dart';

import '../../modules/web_view/web_view_screen.dart';

Widget defaultButton({
  double width = double.infinity,
  Color backGround = Colors.blue,
  bool isUperCase = true,
  double radius = 10,
  required void fun(),
  required String text,
}) {
  return Container(
    width: width,
    height: 40,
    child: MaterialButton(
      child: Text(
        isUperCase ? text.toUpperCase() : text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: fun,
    ),
    decoration: BoxDecoration(
      color: backGround,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

Widget defaultTextButton({
  required void function(),
  required String text,
}) {
  return TextButton(
    onPressed: function,
    child: Text(
      text.toUpperCase(),
    ),
  );
}

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? validate,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isPassowrd = false,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    onFieldSubmitted: (s) {
      onSubmit!(s);
    },
    onChanged: (s) {
      onChange!(s);
    },
    onTap: () {
      onTap!();
    },
    validator: (s) {
      validate??(s);
      if (s == null || s.isEmpty) {
      return 'title must not be empty';
      }
      return null;
    },
    enabled: isClickable,
    obscureText: isPassowrd,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),
      suffixIcon: suffix != null
          ? IconButton(
              icon: Icon(suffix),
              onPressed: () {
                suffixPressed!();
              },
            )
          : null,
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.grey[300],
    ),
  );
}

Widget buildArticleItem(article, context) => InkWell(
      onTap: () {
        Uri url = Uri.parse(article['url']);
        var controller = WebViewController();
        controller.loadRequest(url);
        navigateTo(context, WebViewScreen(controller));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage('${article['urlToImage']}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Container(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${article['title']}',
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${article['publishedAt']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );

Widget myDivider() => Container(
      height: 1,
      color: Colors.grey[200],
    );

Widget articleBuilder(list, context, {isSearch = false}) => ConditionalBuilder(
      condition: list.isNotEmpty,
      builder: (context) => ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildArticleItem(list[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: list.length,
      ),
      fallback: (context) =>
          isSearch ? Container() : Center(child: CircularProgressIndicator()),
    );

void navigateTo(context, widget) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}
void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
        (route) => false,
  );
}
void showToast({
  required String msg,
  required ToastStates state,
})
{
  return Toast.show(
    // state.loginModel.message,
    msg,
    duration: Toast.lengthLong,
    gravity:  Toast.bottom,
    backgroundColor: chooseToastColor(state),
    textStyle: TextStyle(color: Colors.white),
  );
}

enum ToastStates {SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastStates state)
{
  Color color;
  switch(state)
  {
    case ToastStates.SUCCESS: color = Colors.green; break;
    case ToastStates.ERROR: color = Colors.red; break;
    case ToastStates.WARNING: color = Colors.amber; break;
  }
  return color;
}
