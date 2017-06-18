package apps.joan.testoracle;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

public class BienvenidaActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bienvenida);
        getSupportActionBar().setTitle("Alajuela");
        ((ImageView) findViewById(R.id.imgGoToRPH)).setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                startActivity(new Intent(BienvenidaActivity.this, MainActivity.class));
            }
        });

        ((ImageView) findViewById(R.id.imgGoToForms)).setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                startActivity(new Intent(BienvenidaActivity.this, Forms.class));
            }
        });
    }
}
