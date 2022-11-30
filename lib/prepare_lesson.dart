import 'package:mero_school/expandable.dart';

import 'data/models/response/course_details_by_id_response.dart';

const SPLITTER = '|';

class PrepareLesson {
  List root = <Entry?>[];

  List<String> getList(String path) {
    var result = path.split(SPLITTER);
    return result;
  }

  Map<String, List<Entry?>?> allKey = Map();

  List<Entry?> refactorToNested(List<Lessons> lessons) {
    Entry child;

    lessons.forEach((lesson) {
      //first create map to hold the dublicate entries
      List<String> keys = getList(lesson.title!.trim());
      var i = "";
      var space = "";
      keys.forEach((element) {
        i = i + element + "|";
        allKey.putIfAbsent(i, () => <Entry?>[]);
      });

      int level = keys.length + 1;

      List<String> reversed = getList(lesson.title!.trim()).reversed.toList();

      String node = lesson.title!.trim();

      Entry? child;

      reversed.forEach((element) {
        level = level - 1;

        space = space + "   ";
        String parentTag = node.substring(0, node.indexOf(element));
        String childTag = parentTag + element + "|";
        String title = element;

        // print("parentKey="+ parentTag + " , childKey="+ childTag + " ,title= " + title);

        if (child == null) {
          child = Entry(title, <Entry>[], childTag, false, lesson, level);
        } else {
          child = addParent(title, child, childTag, lesson, level);
        }
      });

      root.add(child);
    });

    allKey.forEach((key, value) {
      List<Entry?>? entries = value;

      // print("=====" + key + " ====" + entries.length.toString());
    });

    List<Entry?> filtered = <Entry?>[];
    List<String?> m = <String?>[];

    root.forEach((element) {
      //level 0
      Entry e = element;

      List<String?> n = <String?>[];
      List<Entry> filteredN = <Entry>[];

      e.children!.forEach((element) {
        //level 1
        Entry e = element!;

        List<String?> o = <String?>[];
        List<Entry> filteredO = <Entry>[];

        e.children!.forEach((element) {
          Entry e = element!;

          if (!o.contains(e.mapId)) {
            filteredO.add(e);
            o.add(e.mapId);
          }
        });

        e.children = filteredO;

        if (!n.contains(e.mapId)) {
          filteredN.add(e);
          n.add(e.mapId);
        }
      });

      e.children = filteredN;

      if (!m.contains(e.mapId)) {
        filtered.add(element);
        m.add(e.mapId);
      }
    });

    return filtered;
  }

  //level 1 remove
  Entry removeDuplicateChild(Entry entry) {
    List<Entry?> childrens = entry.children!;

    var changed = <Entry>[];
    List<String?> parse = <String?>[];

    childrens.forEach((element) {
      Entry e = element!;
      if (!parse.contains(e.mapId)) {
        changed.add(e);
        parse.add(e.mapId);
      }
    });

    entry.children = changed;
    return entry;
  }

  Map<String?, Entry> allmap = Map();

  Entry addParent(
      String title, Entry? entry, String id, Lessons lessons, int level) {
    // print("tag" + id);

    Entry parent = Entry(title, <Entry>[], id, false, lessons, level);

    List<Entry?>? old = [];

    if (allKey.containsKey(id)) {
      old = allKey[id];
    }

    old!.add(entry);
    allKey.putIfAbsent(id, () => old);

    parent.children = old;

    return parent;
  }

  void addInMap(Entry entry) {
    if (allmap.containsKey(entry.mapId)) {
      // print("HereDupicate: " + entry.title);

      Entry child = allmap[entry.mapId]!;

      List<Entry?> childrens = [];
      childrens.addAll(child.children!);
      // childrens.add(child);

      entry.children = childrens;
      allmap.update(entry.mapId, (value) => entry);
    } else {
      allmap[entry.mapId] = entry;
    }
  }

  void checkAndAdd(Entry entry) {}

  List<Entry?>? checkArrayContainsKey(String key, List<Entry> jsonArray) {
    List<Entry?>? resultArray = [];

    jsonArray.forEach((it) {
      Entry child = it;
      if (has(child, key)) {
        resultArray = child.children;
      }
    });

    return resultArray;
  }

  bool has(Entry entry, String key) {
    if (entry.title == key) {
      return true;
    }
    return false;
  }
}
