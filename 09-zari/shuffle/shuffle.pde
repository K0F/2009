

void setup(){


   List<String> lista = new ArrayList();
    
    // Add elements to list
    
    // Shuffle the elements in the list
    Collections.shuffle(lista);
    
    // Create an array
    String[] array = new String[]{"a", "b", "c"};
    
    // Shuffle the elements in the array
    Collections.shuffle(Arrays.asList(array));

    println(array);

}
