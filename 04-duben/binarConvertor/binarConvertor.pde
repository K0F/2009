PImage img;
float tresh = 127.0;

void setup(){

	img = loadImage("Kandinsky_OnWhite2.jpg");
	int[][] matrix = new int[img.width][img.height];
	
	for(int x = 0;x<img.width;x++){
		for(int y = 0 ; y<img.height;y++){
			if(brightness(img.pixels[y*img.width+x])>tresh){
					matrix[x][y] = 1;
			}else{
					matrix[x][y] = 0;
			}
		}
	
	}
	
	String[] data = new String[matrix[0].length];

	for(int y = 0;y<matrix[0].length;y++){
		data[y] = "";
		for(int x = 0;x<matrix.length;x++){		
			data[y]+=matrix[x][y]+" ";
		}
	
	}
	
	saveStrings("out.txt",data);
	exit();
}
