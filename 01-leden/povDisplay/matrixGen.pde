
class MatrixGen{
	boolean [][] matr = new boolean[0][0];
	String[] s = new String[0];
	boolean a = false;
	String in;
	boolean working = false;

	MatrixGen(String _in){
		rebuild(_in);
	}

	void rebuild(String _in){
		working = true;
		in = ""+_in.toUpperCase();
		loadF();
		construct();
		matrix = matr;
		working = false;
	}

	void loadF(){
		int pis = 65;
		String[] temp = new String[0];
		s = new String[0];                         
		for(int i =0;i<in.length();i++){
			//print(in.charAt(i));
			
			File a = new File(sketchPath+"/font/"+(in.charAt(i))+".txt");
			if(a.exists()){
				//println();
			temp = loadStrings(a.getPath());
			}
			pis++;

			for(int q = 0;q<temp.length;q++){
				s = (String[])expand(s,s.length+1);
				s[s.length-1] = temp[q];
			}
		}

		println("matrix change: "+in);

	}

	void construct(){
		matr = new boolean[0][0];
		for(int i = 0;i<s.length;i++){
			matr = (boolean[][])expand(matr,matr.length+1);
			matr[matr.length-1] = new boolean[5];

			for(int q = 0;q<s[i].length();q++){
				if((s[i].charAt(q))=='1'){
					matr[matr.length-1][q] = true;
					//print(1);
				}else{
					matr[matr.length-1][q] = false;
					//print(0);
				}
			}
			//println("");

		}

	}
}
