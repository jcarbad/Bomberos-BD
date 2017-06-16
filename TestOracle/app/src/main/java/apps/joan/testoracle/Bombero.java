package apps.joan.testoracle;

/**
 * Created by Joan on 6/14/2017.
 */

public class Bombero {
    private String nombre;
    private int codigo;

    public Bombero(String nombre, int codigo) {
        this.nombre = nombre;
        this.codigo = codigo;
    }

    @Override
    public String toString() {
        return "Bombero{" +
                "nombre='" + nombre + '\'' +
                ", codigo=" + codigo +
                '}';
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getCodigo() {
        return codigo;
    }

    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
}
