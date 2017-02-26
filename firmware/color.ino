#include "InternetButton.h"
#include "math.h"

struct rgbColor {
    unsigned char red;
    unsigned char green;
    unsigned char blue;
};
bool parseColor(const char *colorStr, struct rgbColor &color);

InternetButton b = InternetButton();
float brightness = 0.1;
struct rgbColor currentColor{ 128, 0, 255 };
int howMany = 11;
bool changed = true;
bool unwind = true;

void setup() {
    b.begin();

    Particle.function("color", changeLightColor);

    System.on(reset_pending, beforePowerDown);
    System.disableReset();
}

void loop(){
    //Clicking "up" makes the LEDs brighter
    if(b.buttonOn(1)){
        if(brightness < 1){
            brightness += 0.005;
            changed = true;
        }
    }
    //Clicking "down" makes the LEDs dimmer
    else if (b.buttonOn(3)){
        if(brightness > 0){
            brightness -= 0.005;
            if(brightness < 0){
                brightness = 0;
            }
            changed = true;
        }
    }

    //If anything's been altered by clicking or the Particle.function, update the LEDs
    if(changed){
        delay(10);
        makeColors();
        changed = false;
        unwind = false;
    }
}


void beforePowerDown(system_event_t event, int param, void *reserved) {
    b.allLedsOff();
    System.enableReset();
}

int changeLightColor(String colorStr) {
    struct rgbColor color;
    if(parseColor(colorStr, color)) {
        currentColor = color;
        
        unwind = true;
        changed = true;

        return 0;
    }
    return 1;
}


bool parseColor(const char *colorStr, struct rgbColor &color) {
    if(colorStr[0] == '#' && strlen(colorStr) == 7) {
        long colorCode = strtol(&colorStr[1], NULL, 16);
        color.red = (colorCode >> 16) & 0xFF;
        color.green = (colorCode >> 8) & 0xFF;
        color.blue = colorCode & 0xFF;
        return true;
    }
    
    return false;
}

//Uses the brightness and the color values to compute what to show
void makeColors() {
    uint8_t red = currentColor.red * brightness;
    uint8_t green = currentColor.green * brightness;
    uint8_t blue = currentColor.blue * brightness;
    
    if(unwind) {
        const int pace = 50;
        for(int i = howMany; i > 1; i--) {
            b.ledOff(i);
            delay(pace);
        }
        delay(pace);
        for(int i = 1; i <= howMany; i++){
            b.ledOn(i, red, green, blue);
            delay(pace);
        }
    } else {
        b.allLedsOff();
        for(int i = 1; i <= howMany; i++){
            b.ledOn(i, red, green, blue);
        }
    }
}
