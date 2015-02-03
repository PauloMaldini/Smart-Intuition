//
//  Texture2D.m
//  Smart Intuition
//
//  Created by Konstantin Tsymbalist on 11.02.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "Texture2D.h"

@implementation Texture2D

+(void) loadTextureWithFileName:(NSString *)fileName SavedIn:(GLuint *)textureID SaveWidthIn:(GLfloat *)width SaveHeightIn:(GLfloat *)height
{
    CGImageRef spriteImage;
    CGContextRef spriteContext;
    GLubyte *spriteData;
    size_t  textureWidth, textureHeight;
    
    // Creates a Core Graphics image from an image file
    spriteImage = [UIImage imageNamed: fileName].CGImage;
    // Get the width and height of the image
    size_t imageWidth = textureWidth = CGImageGetWidth(spriteImage);
    size_t imageHeight = textureHeight = CGImageGetHeight(spriteImage);
    *width = 0;
    *height = 0;
    // Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
    // you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
    
    if(spriteImage) 
    {
        int w = 2, h = 2;
        while (w  < textureWidth)
            w = w << 1;
        while (h < textureHeight)
            h = h << 1;
        
        textureWidth = w;
        textureHeight = h;
        
        *width = textureWidth;
        *height = textureHeight;
               
        // Allocated memory needed for the bitmap context
        spriteData = (GLubyte *) calloc(textureWidth * textureHeight * 4, sizeof(GLubyte));
        // Uses the bitmap creation function provided by the Core Graphics framework.
        CGColorSpaceRef csr = CGImageGetColorSpace(spriteImage);
        spriteContext = CGBitmapContextCreate(spriteData, textureWidth, textureHeight, 8, textureWidth * 4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
        // After you create the context, you can draw the sprite image to the context.
        CGContextDrawImage(spriteContext, CGRectMake(0.0, textureHeight - imageHeight, (CGFloat)imageWidth, (CGFloat)imageHeight), spriteImage);
        // You don't need the context at this point, so you need to release it to avoid memory leaks.
        CGContextRelease(spriteContext);
        
        // Use OpenGL ES to generate a name for the texture.
        glGenTextures(1, textureID);
        // Bind the texture name.
        glBindTexture(GL_TEXTURE_2D, *textureID);
        // Set the texture parameters to use a minifying filter and a linear filter (weighted average)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  
        glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
        
        // Specify a 2D texture image, providing the a pointer to the image data in memory
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureWidth, textureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
        // Release the image data
        free(spriteData);
        
        glBindTexture(GL_TEXTURE_2D, 0);
    }
}


@end
