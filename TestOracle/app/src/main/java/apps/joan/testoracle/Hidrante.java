package apps.joan.testoracle;

import android.location.Location;
import android.os.Parcel;
import android.os.Parcelable;

import com.google.android.gms.maps.model.LatLng;

import java.math.BigDecimal;

public class Hidrante implements Parcelable{
    private BigDecimal latitud, longitud, calle, avenida, caudal, estado, pendiente, distancia;
    private int[] salidas;
    private String ultima_revision;

    public Hidrante(BigDecimal lat, BigDecimal longi, BigDecimal calle, BigDecimal ave, BigDecimal caudal, int[] salidas, BigDecimal estado, String ult_rev, BigDecimal pendiente, BigDecimal distancia){
        this.latitud = lat;
        this.longitud = longi;
        this.calle = calle;
        this.avenida = ave;
        this.caudal = caudal;
        this.salidas = salidas;
        this.estado = estado;
        this.ultima_revision = ult_rev;
        this.pendiente = pendiente;
        this.distancia = distancia;
    }

    public Hidrante(double lat, double longi, int calle, int ave, double caud, int[] sal, int est, String fechU, int pend){
        this(new BigDecimal(lat), new BigDecimal(longi), new BigDecimal(calle), new BigDecimal(ave), new BigDecimal(caud), sal, new BigDecimal(est), fechU, new BigDecimal(pend), new BigDecimal(0));
    }

    public Hidrante(Parcel in){
        this(in.readDouble(), in.readDouble(), in.readInt(), in.readInt(), in.readDouble(), in.createIntArray(), in.readInt(), in.readString(), in.readInt());
        this.distancia = new BigDecimal(in.readDouble());
    }
// <editor-fold defaultstate="collapsed"  desc"SETs & GETs">
    public BigDecimal getLatitud() {
        return latitud;
    }

    public void setLatitud(BigDecimal latitud) {
        this.latitud = latitud;
    }

    public BigDecimal getLongitud() {
        return longitud;
    }

    public void setLongitud(BigDecimal longitud) {
        this.longitud = longitud;
    }

    public BigDecimal getCalle() {
        return calle;
    }

    public void setCalle(BigDecimal calle) {
        this.calle = calle;
    }

    public BigDecimal getAvenida() {
        return avenida;
    }

    public void setAvenida(BigDecimal avenida) {
        this.avenida = avenida;
    }

    public BigDecimal getCaudal() {
        return caudal;
    }

    public void setCaudal(BigDecimal caudal) {
        this.caudal = caudal;
    }

    public BigDecimal getEstado() {
        return estado;
    }

    public void setEstado(BigDecimal estado) {
        this.estado = estado;
    }

    public BigDecimal getPendiente() {
        return pendiente;
    }

    public void setPendiente(BigDecimal pendiente) {
        this.pendiente = pendiente;
    }

    public int[] getSalidas() {
        return salidas;
    }

    public void setSalidas(int[] salidas) {
        this.salidas = salidas;
    }

    public String getUltima_revision() {
        return ultima_revision;
    }

    public void setUltima_revision(String ultima_revision) {
        this.ultima_revision = ultima_revision;
    }

    public BigDecimal getDistancia(){
        return this.distancia;
    }

    public void setDistancia(double dist){
        this.distancia = new BigDecimal(dist);
    }
// </editor-fold>

    public BigDecimal distancia_A_m(LatLng camion){
        Location locCamion = new Location(""), locHidrante = new Location("");
        locCamion.setLatitude(camion.latitude);
        locCamion.setLongitude(camion.longitude);
        locHidrante.setLatitude(this.latitud.doubleValue());
        locHidrante.setLongitude(this.longitud.doubleValue());
        this.distancia = new BigDecimal(locCamion.distanceTo(locHidrante));
        return this.distancia;
    }
    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {

        dest.writeDouble(latitud.doubleValue());
        dest.writeDouble(longitud.doubleValue());
        dest.writeInt(calle.intValue());
        dest.writeInt(avenida.intValue());
        dest.writeDouble(caudal.doubleValue());
        dest.writeIntArray(salidas);
        dest.writeInt(estado.intValue());
        dest.writeString(ultima_revision);
        dest.writeInt(pendiente.intValue());
        dest.writeDouble(distancia.doubleValue());
    }

    public static final Parcelable.Creator<Hidrante> CREATOR;

    static {
        CREATOR = new Creator<Hidrante>() {
            @Override
            public Hidrante createFromParcel(Parcel in){
                return new Hidrante(in);
            }

            @Override
            public Hidrante[] newArray(int size){
                return new Hidrante[size];
            }
        };
    }
}
