package apps.joan.testoracle;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.Circle;
import com.google.android.gms.maps.model.CircleOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

import java.util.ArrayList;

public class MapsActivity extends FragmentActivity implements OnMapReadyCallback {

    private GoogleMap mMap;
    ArrayList<Hidrante> hidrantes;
    double[] Coords;
    int radio;

    // Elemento UI
    private ImageView imgZoomIn, imgZoomOut, imgListado;
    private TextView lblListado;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_maps);
        lblListado = (TextView) findViewById(R.id.lblListado);
        imgZoomIn = (ImageView) findViewById(R.id.imgZoomIn);
        imgZoomOut = (ImageView) findViewById(R.id.imgZoomOut);
        imgListado = (ImageView) findViewById(R.id.imgListado);
        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);
        hidrantes = getIntent().getParcelableArrayListExtra("hidrantes");
        Coords = getIntent().getDoubleArrayExtra("coords");
        radio = getIntent().getIntExtra("radio", 0);

        registrarOnClicks(R.id.imgZoomIn);
        registrarOnClicks(R.id.imgZoomOut);
        registrarOnClicks(R.id.imgListado);
        lblListado.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                imgListado.performClick();
            }
        });
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;

        LatLng PCA = new LatLng(Coords[0], Coords[1]); // Parque Central de Alajuela
        int zoomLevel = 13;
        mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(PCA, zoomLevel));
        mMap.addMarker(new MarkerOptions()
                .position(PCA)
                .title("Mi ubicación")
                .icon(BitmapDescriptorFactory.fromResource(R.drawable.camion32))
        );

        for (Hidrante hidra : hidrantes){
            MarkerOptions marker = new MarkerOptions()
                    .position(new LatLng(hidra.getLatitud().doubleValue(), hidra.getLongitud().doubleValue()))
                    .title("Calle " + hidra.getCalle().intValue() + " y Avenida " + hidra.getAvenida().intValue() + "  (" + hidra.distancia_A_m(PCA).intValue() + " m)")
                    .icon(BitmapDescriptorFactory.fromResource(hidra.getEstado().intValue() == 1 ? R.drawable.hidrante24: R.drawable.hidrante_malo24));
            mMap.addMarker(marker);
        }
        TrazarRPH();
    }

    private void TrazarRPH() {
        // Instantiates a new CircleOptions object and defines the center and radius
        CircleOptions circleOptions = new CircleOptions()
                .center(new LatLng(Coords[0], Coords[1]))
                .fillColor(0x1A0000ff)
                .strokeColor(Color.TRANSPARENT)
                .radius(radio); // In meters

        Circle circle = mMap.addCircle(circleOptions);
    }

    public void registrarOnClicks(int ref) {
        ImageView miImageView = (ImageView) findViewById(ref);
        miImageView.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                switch (v.getId()) {
                    case R.id.imgZoomIn:
                        mMap.animateCamera(CameraUpdateFactory.zoomIn());
                        break;
                    case R.id.imgZoomOut:
                        mMap.animateCamera(CameraUpdateFactory.zoomOut());
                        break;
                    case R.id.imgListado:
                        ArrayList<Hidrante> listado = hidrantes;
                        Intent intento = new Intent(getApplicationContext(), ListadoHidrantes.class);
                        Bundle b = new Bundle();
                        b.putParcelableArrayList("hidrantes", listado);
                        intento.putExtras(b);
                        intento.putExtra("coords", Coords);
                        intento.putExtra("radio", radio);
                        startActivity(intento);
                        break;
                    default:break;
                }
            }
        });
    }
}
