import java.io.File;

Button enter, nojruby, winver;
String processingRoot = "enter your processing root here"; // edit this line in the sketch
String done = "Done";
String OS = System.getProperty("os.name").toLowerCase();
String home, suggestion, separator, root, sketchbookPath;
PFont font;
float rectX, rectX2, rectX3, rectY;      // Position of buttons
float rectHeight = 30;           // height of rect
float rectWidth = 90;            // width of rect
int rectColor, rectColor2, rectColor3;
int rectHighlight, rectHighlight2, rectHighlight3;
int currentColor;
int selectedColor, selectedColor2, selectedColor3;
boolean acceptOver = false;
boolean noJruby = false;
boolean selected = false;
boolean eightOne = false;
String jruby = "true";
// The JSON object
JSONObject json;

void setup() {
  size(600, 200);
  home = System.getProperty("user.home");
  File f = new File(home);
  json = new JSONObject();
  root = f.getParent();
  separator = System.getProperty("file.separator");
  font = createFont("Helvetica", 18);
  if (OS.contains("mac")) {
    suggestion = "/Applications/Processing.app/Contents/Resources/Java";
    sketchbookPath = home + separator + "Documents/Processing/sketchbook";
  } else if (OS.contains("windows")) {
    sketchbookPath = (eightOne) ? home + separator + "Documents" + separator +"sketchbook" :
    home + separator + "My Documents" + separator +"sketchbook";
    suggestion = home + separator + "processing-2.2.1";
  } else {
    sketchbookPath = home + separator + "sketchbook";
    suggestion = home + separator + "processing-2.2.1";
  }
  rectColor = color(140);
  rectColor2 = color(140);
  rectColor3 = color(140);
  rectHighlight = color(100);
  rectHighlight2 = color(100);
  rectHighlight3 = color(100);
  selectedColor = color(0);
  selectedColor2 = color(0);
  selectedColor3 = color(0);
  rectX = rectWidth + 20;
  rectX2 = rectWidth + 150;
  rectX3 = rectWidth + 300;
  rectY = height * 0.8 - rectHeight / 4;
  enter = new Button(rectX2, rectY, rectWidth, rectHeight, "enter");
  nojruby = new Button(rectX, rectY, rectWidth, rectHeight, "nojruby");
  winver = new Button(rectX3, rectY, rectWidth, rectHeight, "Win 8.1+");
}

void draw() {
  background(200);
  fill(0, 0, 200);
  text("Suggestion:", 35, 28);
  text(suggestion, 35, 56);
  textFont(font, 18);
  fill(255, 0, 0);
  // this adds a blinking cursor after your text, at the expense of redrawing everything every frame
  text(processingRoot + (frameCount / 10 % 2 == 0 ? "_" : ""), 35, 100);
  fill(0, 0, 200);
  text("Select nojruby to use jruby-complete by default", 35, 140);
  update(mouseX, mouseY);
  //background(200);

  if (acceptOver) {
    enter.draw(rectHighlight);
    nojruby.draw(rectHighlight2);
    winver.draw(rectHighlight3);
  } else {
    enter.draw(rectColor);
    nojruby.draw(rectColor2);
    winver.draw(rectColor3);
  }
}

void writeRoot() {
  rectColor = selectedColor;
  rectHighlight = selectedColor;
  json.setString("PROCESSING_ROOT", processingRoot);
  json.setString("JRUBY", jruby);
  json.setString("sketchbook_path", sketchbookPath);
  json.setInt("X_OFF", floor(displayWidth * 0.1));
  json.setInt("Y_OFF", floor(displayHeight * 0.1));

  saveJSONObject(json, home + separator + ".rp5rc");
  processingRoot = done;
}


void keyReleased() {
  if (key != CODED) {
    switch (key) {
    case BACKSPACE:
      processingRoot = processingRoot.substring(0, max(0, processingRoot.length() - 1));
      break;
    case ENTER: // save the processing root to the config file
    case RETURN:
      writeRoot();
      break;
    case ESC:
    case DELETE:
      break;
    default:
      processingRoot += key;
    }
  }
}

void update(float x, float y) {
  acceptOver = enter.overRect();
  noJruby = nojruby.overRect();
}



void mouseClicked() {
  update(mouseX, mouseY);
  if (acceptOver) {
    rectColor = selectedColor;
    rectHighlight = selectedColor;
    writeRoot();
  } else if (noJruby) {
    rectColor2 = selectedColor2;
    rectHighlight2 = selectedColor2;
    jruby = "false";
  } else if (!eightOne) {
    rectColor3 = selectedColor3;
    rectHighlight3 = selectedColor3;
    eightOne = true;
  }
}

class Button {

  float x, y, w, h;
  String text;

  Button(float x, float y, float w, float h, String text) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
  }

  void draw(int col) {
    fill(col);
    rect(x, y, w, h, 20, 20, 20, 20);
    fill(255);
    text(text, x + 8, y + 20);
  }

  boolean overRect() {
    return (mouseX >= x && mouseX <= x + w
      && mouseY >= y && mouseY <= y + h);
  }
}

