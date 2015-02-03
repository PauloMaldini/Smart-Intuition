//
//  CSpriteStorage.m
//  Smart Intuition
//
//  Created by Konstantin Tsymbalist on 10.02.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CSpriteStorage.h"
#import "CSprite.h"
#import "Texture2D.h"
#import "CCamera.h"
#import "CSector.h"
#import "CAbstractScene.h"

@implementation CSpriteStorage

@synthesize fillType;
@synthesize count; 
@synthesize textureAtlasWidth;
@synthesize textureAtlasHeight;
@synthesize alpha;

- (id) initWithSpriteCount:(ushort)_maxSpriteCount
               WithTexture:(NSString *)_fileName
              WithFillType:(enum EFillType)_fillType
             WithGameScene:(CAbstractScene *)_scene
{
    if(self = [super init])
    {
        //Выделяем память под массивы
        indexArray = malloc(6*sizeof(ushort)*_maxSpriteCount);
        if (_fillType == ftTexture)
            vertexTextureColorArray = malloc(4*sizeof(SVertexTextureColorArrayElem)*_maxSpriteCount);
        else if (_fillType == ftColor)
            vertexColorArray = malloc(4*sizeof(SVertexColorArrayElem)*_maxSpriteCount);
        
        elements = malloc(sizeof(SSpriteArrayElement)*_maxSpriteCount);
        
        //Загружаем текстуру
        [Texture2D loadTextureWithFileName:_fileName SavedIn:&textureAtlas SaveWidthIn:&textureAtlasWidth SaveHeightIn:&textureAtlasHeight];
        
        if (_fillType == ftTexture && (!textureAtlasWidth || !textureAtlasHeight))
        {
            [self dealloc];
            return nil;
        }

        //Инициализируем другие члены-данные
        fillType = _fillType;
        count = 0;
        scene = _scene;
    }
    
    return(self);
}

- (void) addSprite:(CSprite *)_sprite
{
    //Добавляем индексы вершин в массив индексов
    unsigned short spriteIndexes[6];
    spriteIndexes[0] = count*4;
    spriteIndexes[1] = count*4;
    spriteIndexes[2] = count*4 + 1;
    spriteIndexes[3] = count*4 + 2;
    spriteIndexes[4] = count*4 + 3;
    spriteIndexes[5] = count*4 + 3;
    
    for (int i = 0; i < 6; i++)
        indexArray[count*6 + i] = spriteIndexes[i];
    
    //Добавляем спрайт в массив спрайтов
    elements[count].sprite = _sprite;
    elements[count].posInIndexArray = indexArray + count*6;
    count++;
}

- (CSprite *) getSpriteByIndex:(uint)_index
{
    return(elements[_index].sprite);
}

- (void) deleteSprite
{
    
}
 
- (void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage 
{
    for (int i = 0; i < count; i++)
    {
        //Если спрайт привязан к камере, то нужно прибавлять ее координаты, поэтому получаем координаты камеры
        GLfloat cameraX;
        GLfloat cameraY;
        if (elements[i].sprite.camera)
        {
            cameraX = elements[i].sprite.camera.position.x;
            cameraY = elements[i].sprite.camera.position.y;
        }
        else
        {
            cameraX = 0;
            cameraY = 0;
        }
        
        //Если сцена разбита на сектора, и спрайт привязан к сектору, то обновляем сектор спрайта
        if (scene.sectors && elements[i].sprite.isSector)
        {
            CSprite *sprite = elements[i].sprite;
            [elements[i].sprite.sector removeSprite:sprite];
            [scene.sectors[(int)((elements[i].sprite.rect.a.x + cameraX)/scene.sectorSize.width)][(int)((elements[i].sprite.rect.a.y + cameraY)/scene.sectorSize.height)] addSprite:sprite];
        }
        
        //Двигаем спрайт
        [elements[i].sprite move:deltaTime :touchMessage :accelerometerMessage];
        
        //Обновляем вершинные, текстурные/цветовые координаты спрайта в vertex array
        if (fillType == ftTexture) //Полигоны текстурируются
        {
            SVertexTextureColorArrayElem ver_tex_color_coords[4];
            
            ver_tex_color_coords[0].position[0] = (short)(elements[i].sprite.rect.a.x) + cameraX;
            ver_tex_color_coords[0].position[1] = (short)(elements[i].sprite.rect.a.y) + cameraY;
            ver_tex_color_coords[0].texture[0] = elements[i].sprite.image.origin.x;
            ver_tex_color_coords[0].texture[1] = elements[i].sprite.image.origin.y;
            ver_tex_color_coords[0].color[0] = elements[i].sprite.color.red;           
            ver_tex_color_coords[0].color[1] = elements[i].sprite.color.green;            
            ver_tex_color_coords[0].color[2] = elements[i].sprite.color.blue;
            ver_tex_color_coords[0].color[3] = elements[i].sprite.color.alpha;
            
            ver_tex_color_coords[1].position[0] = (short)(elements[i].sprite.rect.b.x) + cameraX;
            ver_tex_color_coords[1].position[1] = (short)(elements[i].sprite.rect.b.y) + cameraY;
            ver_tex_color_coords[1].texture[0] = elements[i].sprite.image.origin.x + elements[i].sprite.image.size.width;
            ver_tex_color_coords[1].texture[1] = elements[i].sprite.image.origin.y;
            ver_tex_color_coords[1].color[0] = elements[i].sprite.color.red;   
            ver_tex_color_coords[1].color[1] = elements[i].sprite.color.green;
            ver_tex_color_coords[1].color[2] = elements[i].sprite.color.blue;
            ver_tex_color_coords[1].color[3] = elements[i].sprite.color.alpha;
            
            ver_tex_color_coords[2].position[0] = (short)(elements[i].sprite.rect.c.x) + cameraX;
            ver_tex_color_coords[2].position[1] = (short)(elements[i].sprite.rect.c.y) + cameraY;
            ver_tex_color_coords[2].texture[0] = elements[i].sprite.image.origin.x;
            ver_tex_color_coords[2].texture[1] = elements[i].sprite.image.origin.y + elements[i].sprite.image.size.height;
            ver_tex_color_coords[2].color[0] = elements[i].sprite.color.red;            
            ver_tex_color_coords[2].color[1] = elements[i].sprite.color.green;
            ver_tex_color_coords[2].color[2] = elements[i].sprite.color.blue;           
            ver_tex_color_coords[2].color[3] = elements[i].sprite.color.alpha;                        

            ver_tex_color_coords[3].position[0] = (short)(elements[i].sprite.rect.d.x) + cameraX;
            ver_tex_color_coords[3].position[1] = (short)(elements[i].sprite.rect.d.y) + cameraY;
            ver_tex_color_coords[3].texture[0] = elements[i].sprite.image.origin.x + elements[i].sprite.image.size.width;
            ver_tex_color_coords[3].texture[1] = elements[i].sprite.image.origin.y + elements[i].sprite.image.size.height;
            ver_tex_color_coords[3].color[0] = elements[i].sprite.color.red;            
            ver_tex_color_coords[3].color[1] = elements[i].sprite.color.green;            
            ver_tex_color_coords[3].color[2] = elements[i].sprite.color.blue;            
            ver_tex_color_coords[3].color[3] = elements[i].sprite.color.alpha;                        
      
            vertexTextureColorArray[i*4]     = ver_tex_color_coords[0];
            vertexTextureColorArray[i*4 + 1] = ver_tex_color_coords[1];
            vertexTextureColorArray[i*4 + 2] = ver_tex_color_coords[2];
            vertexTextureColorArray[i*4 + 3] = ver_tex_color_coords[3];
        }
        else if (fillType == ftColor) //Полигоны красятся цветом
        {
            SVertexColorArrayElem ver_color_coords[4];
            
            ver_color_coords[0].position[0] = (short)(elements[i].sprite.rect.a.x) + cameraX;
            ver_color_coords[0].position[1] = (short)(elements[i].sprite.rect.a.y) + cameraY;
            ver_color_coords[0].color[0] = elements[i].sprite.color.red;            
            ver_color_coords[0].color[1] = elements[i].sprite.color.green;            
            ver_color_coords[0].color[2] = elements[i].sprite.color.blue;            
            ver_color_coords[0].color[3] = elements[i].sprite.color.alpha;                        
            
            ver_color_coords[1].position[0] = (short)(elements[i].sprite.rect.b.x) + cameraX;
            ver_color_coords[1].position[1] = (short)(elements[i].sprite.rect.b.y) + cameraY;
            ver_color_coords[1].color[0] = elements[i].sprite.color.red;            
            ver_color_coords[1].color[1] = elements[i].sprite.color.green;            
            ver_color_coords[1].color[2] = elements[i].sprite.color.blue;           
            ver_color_coords[1].color[3] = elements[i].sprite.color.alpha;                        
            
            ver_color_coords[2].position[0] = (short)(elements[i].sprite.rect.c.x) + cameraX;
            ver_color_coords[2].position[1] = (short)(elements[i].sprite.rect.c.y) + cameraY;
            ver_color_coords[2].color[0] = elements[i].sprite.color.red;          
            ver_color_coords[2].color[1] = elements[i].sprite.color.green;
            ver_color_coords[2].color[2] = elements[i].sprite.color.blue;          
            ver_color_coords[2].color[3] = elements[i].sprite.color.alpha;
            
            ver_color_coords[3].position[0] = (short)(elements[i].sprite.rect.d.x) + cameraX;
            ver_color_coords[3].position[1] = (short)(elements[i].sprite.rect.d.y) + cameraY;
            ver_color_coords[3].color[0] = elements[i].sprite.color.red;      
            ver_color_coords[3].color[1] = elements[i].sprite.color.green;
            ver_color_coords[3].color[2] = elements[i].sprite.color.blue;          
            ver_color_coords[3].color[3] = elements[i].sprite.color.alpha;
     
            vertexColorArray[i*4]     = ver_color_coords[0];
            vertexColorArray[i*4 + 1] = ver_color_coords[1];
            vertexColorArray[i*4 + 2] = ver_color_coords[2];
            vertexColorArray[i*4 + 3] = ver_color_coords[3];
        }
    }    
}

- (void) render
{
    //Подключаем необходимые массивы
    glEnableClientState(GL_VERTEX_ARRAY); //Включаем использование массива вершинных координат
        
    if (fillType == ftTexture)
    {
        //Привязываем атлас текстур данного хранилища спрайтов
        glBindTexture(GL_TEXTURE_2D, textureAtlas); 
        
        //Включаем использование цветового массива
        glEnableClientState(GL_COLOR_ARRAY); 
        
        //Включаем использование массива текстурных координат
        glEnableClientState(GL_TEXTURE_COORD_ARRAY); 
        
        //Привязываем массив вершинных координат
        glVertexPointer(2, GL_SHORT, sizeof(SVertexTextureColorArrayElem), &vertexTextureColorArray[0].position);
        
        //Привязываем массив текстурных координат
        glTexCoordPointer(2, GL_FLOAT, sizeof(SVertexTextureColorArrayElem), &vertexTextureColorArray[0].texture);
        
        //Привязываем цветовой массив
        glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(SVertexTextureColorArrayElem), &vertexTextureColorArray[0].color); 
    }
    else if (fillType == ftColor)
    {
        //Текстуры не нужны
        glBindTexture(GL_TEXTURE_2D, 0); 
        
        //Отключаем использование массива текстурных координат
        glDisableClientState(GL_TEXTURE_COORD_ARRAY); 
        
        //Включаем использование цветового массива
        glEnableClientState(GL_COLOR_ARRAY); 
        
        //Привязываем массив вершинных координат
        glVertexPointer(2, GL_SHORT, sizeof(SVertexColorArrayElem), &vertexColorArray[0].position);
        
        //Привязываем цветовой массив
        glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(SVertexColorArrayElem), &vertexColorArray[0].color); 
    }
    
    //Выводим сцену в буфер
    glDrawElements(GL_TRIANGLE_STRIP, count*6, GL_UNSIGNED_SHORT, indexArray);
    
    glBindTexture(GL_TEXTURE_2D, 0);
}

- (void) clear
{
    for (int i = 0; i < count; i++)
        [elements[i].sprite release];

    count = 0;
}

- (void) dealloc
{
    //Освобождаем память
    [self clear];
    if (textureAtlas)
        glDeleteTextures(1, &textureAtlas);
    
    [super dealloc];
}


@end
