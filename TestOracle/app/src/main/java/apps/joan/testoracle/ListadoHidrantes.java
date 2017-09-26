package apps.joan.testoracle;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class ListadoHidrantes extends AppCompatActivity {
    ListView listViewHidrantes;
    List<Hidrante> listHidrantes = new ArrayList<>();
    ArrayAdapter<Hidrante> adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_listado_hidrantes);
        setTitle("Hidrantes en RPH");
        listViewHidrantes = (ListView) findViewById(R.id.ListViewHidrantes);
        listHidrantes = getIntent().getParcelableArrayListExtra("hidrantes");
        Collections.sort(listHidrantes, new Comparator<Hidrante>() {
            @Override
            public int compare(Hidrante o1, Hidrante o2) {
                return o1.getDistancia().compareTo(o2.getDistancia());
            }
        });
        adapter = new AdapterHidrantes();
        listViewHidrantes.setAdapter(adapter);
    }

    private class AdapterHidrantes extends ArrayAdapter<Hidrante> {
        public AdapterHidrantes(){
            super(ListadoHidrantes.this, R.layout.layout_un_hidrante, listHidrantes);
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent){
            View itemHdrante = convertView;
            if (itemHdrante == null)
                itemHdrante = getLayoutInflater().inflate(R.layout.layout_un_hidrante, parent, false);

            Hidrante actual = listHidrantes.get(position);

            TextView ubicacion = (TextView) itemHdrante.findViewById(R.id.txtUbicacion);
            ubicacion.setText("Calle " + actual.getCalle().intValue() + ", Avenida " + actual.getAvenida().intValue());

            TextView distancia = (TextView) itemHdrante.findViewById(R.id.txtDistancia);
            distancia.setText("" + Double.toString(actual.getDistancia().setScale(1, BigDecimal.ROUND_HALF_UP).doubleValue()));

            TextView caudal = (TextView) itemHdrante.findViewById(R.id.txtCaudal);
            caudal.setText("" + Double.toString(actual.getCaudal().doubleValue()));

            TextView salidas = (TextView) itemHdrante.findViewById(R.id.txtSalidas);
            String sals = "";
            int i;
            for (i = 0; i < actual.getSalidas().length - 1; i++)
                sals += actual.getSalidas()[i] + ", ";
            sals += actual.getSalidas()[i];
            salidas.setText(sals);

            ImageView imgIco = (ImageView) itemHdrante.findViewById(R.id.imgIcoHidrante);
            if (actual.getEstado().intValue() == 0)
                imgIco.setImageResource(R.drawable.hidrante_malo64);


            return itemHdrante;
        }
    }
}
