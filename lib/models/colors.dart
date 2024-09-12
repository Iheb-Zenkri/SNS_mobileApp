import 'package:flutter/material.dart';
   
Color colorFromHSV(double hue, double saturation, double brightness) {
  HSVColor hsvColor = HSVColor.fromAHSV(1.0, hue, saturation, brightness);
  return hsvColor.toColor();
}
//primary color and shades
Color primaryColor100 = colorFromHSV(220, 0.03, 1.0);  
Color primaryColor200 = colorFromHSV(271, 0.34, 0.96);  
Color primaryColor300 = colorFromHSV(271, 0.52, 0.92); 
Color primaryColor = colorFromHSV(271, 0.77, 0.91); 
Color primaryColor600 = colorFromHSV(271, 0.85, 0.68); 
Color primaryColor700 = colorFromHSV(271, 0.92, 0.46);
Color primaryColor800 = colorFromHSV(271, 1, 0.24); 

//neutral color and shades
Color neutralColor100 = colorFromHSV(271, 0.05, 0.88);  
Color neutralColor200 = colorFromHSV(271, 0.15, 0.71);  
Color neutralColor300 = colorFromHSV(271, 0.28, 0.5); 
Color neutralColor = colorFromHSV(271, 0.33, 0.41); 
Color neutralColor600 = colorFromHSV(271, 0.53, 0.27); 
Color neutralColor700 = colorFromHSV(271, 0.63, 0.19);
Color neutralColor800 = colorFromHSV(271, 0.83, 0.12); 

// Alert color and its shades
Color alertColor100 = colorFromHSV(4, 0.08, 1.0);  
Color alertColor200 = colorFromHSV(4, 0.34, 0.96);  
Color alertColor300 = colorFromHSV(4, 0.52, 0.92); 
Color alertColor = colorFromHSV(4, 0.77, 0.91); 
Color alertColor600 = colorFromHSV(4, 0.85, 0.68); 
Color alertColor700 = colorFromHSV(4, 0.92, 0.46);
Color alertColor800 = colorFromHSV(4, 1, 0.24); 

// Success color and its shades
Color successColor100 = colorFromHSV(132, 0.08, 1.0);  
Color successColor200 = colorFromHSV(132, 0.34, 0.96);  
Color successColor300 = colorFromHSV(132, 0.52, 0.92); 
Color successColor = colorFromHSV(132, 0.77, 0.91); 
Color successColor600 = colorFromHSV(132, 0.85, 0.68); 
Color successColor700 = colorFromHSV(132, 0.92, 0.46);
Color successColor800 = colorFromHSV(132, 1, 0.24); 

// Warning color and its shades
Color warningColor100 = colorFromHSV(45, 0.08, 1.0);  
Color warningColor200 = colorFromHSV(45, 0.34, 0.96);  
Color warningColor300 = colorFromHSV(45, 0.52, 0.92); 
Color warningColor = colorFromHSV(45, 0.77, 0.91); 
Color warningColor600 = colorFromHSV(45, 0.85, 0.68); 
Color warningColor700 = colorFromHSV(45, 0.92, 0.46);
Color warningColor800 = colorFromHSV(45, 1, 0.24); 

// Information color and its shades
Color informationColor100 = colorFromHSV(220, 0.08, 1.0);  
Color informationColor200 = colorFromHSV(220, 0.34, 0.96);  
Color informationColor300 = colorFromHSV(220, 0.52, 0.92); 
Color informationColor = colorFromHSV(220, 0.77, 0.91); 
Color informationColor600 = colorFromHSV(220, 0.85, 0.68); 
Color informationColor700 = colorFromHSV(220, 0.92, 0.46);
Color informationColor800 = colorFromHSV(220, 1, 0.24); 