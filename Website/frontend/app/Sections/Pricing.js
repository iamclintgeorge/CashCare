import React from 'react'
import { Container, Grid, Card, CardContent, Typography, Button } from '@mui/material'

const Pricing = () => {
  return (
    <>
      <div className="bg-gray-200">
      <h1 className="text-black text-6xl font-semibold pl-9 pt-14 flex justify-center">Pricing</h1>
      <Container style={{padding: '40px'}}>
               <Grid container spacing={3} justifyContent="center">
                   <Grid item xs={12} sm={4}>

                        <Card sx={{ height: '400px', width: '300px', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', padding: '20px' , borderRadius: '16px' }}>
                            <div>
                                <Typography variant="h5" sx={{ marginBottom: '10px' }}>Free Plan</Typography>
                                <Typography variant="h4" sx={{ marginBottom: '5px' , fontWeight: 'bold' , display: 'inline-flex', alignItems: 'baseline'}}>$0</Typography>
                                <Typography component="span" sx={{ fontWeight: 'normal', fontSize: '1rem', marginLeft: '4px' }}>/ month</Typography>
                            </div>
                            <Button variant="contained" sx={{ backgroundColor: 'black', color: 'white', marginTop: 'auto', alignSelf: 'center' , padding: '8px 40px'}}>
                                Learn more
                            </Button>
                        </Card>
                   </Grid>
                   <Grid item xs={12} sm={4}>
                       <Card sx={{ height: '400px', width: '300px', marginLeft: '38px' , display: 'flex', flexDirection: 'column', justifyContent: 'space-between', padding: '20px' , borderRadius: '16px'}}>
                            <div>
                               <Typography variant="h5" sx={{ marginBottom: '10px' }}>Premium</Typography>
                               <Typography variant="h4" sx={{ marginBottom: '5px' , fontWeight: 'bold' , display: 'inline-flex', alignItems: 'baseline'}}>$50 </Typography>
                              <Typography component="span" sx={{ fontWeight: 'normal', fontSize: '1rem', marginLeft: '4px' }}>/ month</Typography>
                            </div>  
                               <Button variant="contained" sx={{ backgroundColor: 'black', color: 'white',  marginTop: 'auto', alignSelf: 'center' , padding: '8px 40px'}}>
                                   Learn more
                               </Button>
                       </Card>
                   </Grid>
                   <Grid item xs={12} sm={4}>
                       <Card sx={{ height: '400px', width: '300px', marginLeft: '60px' , display: 'flex', flexDirection: 'column', justifyContent: 'space-between', padding: '20px'  , borderRadius: '16px'}}>
                            <div>
                               <Typography variant="h5" sx={{ marginBottom: '10px' }}>Enterprise</Typography>
                               <Typography variant="h4" sx={{ marginBottom: '5px' , fontWeight: 'bold', display: 'inline-flex', alignItems: 'baseline'}}>$150</Typography>
                               <Typography component="span" sx={{ fontWeight: 'normal', fontSize: '1rem', marginLeft: '4px' }}>/ month</Typography>
                            </div>   
                               <Button variant="contained" sx={{ backgroundColor: 'black', color: 'white', marginTop: 'auto', alignSelf: 'center' , padding: '8px 40px'}}>
                                   Learn more
                               </Button>
                       </Card>
                   </Grid>
               </Grid>
               <div style={{ textAlign: 'center', marginTop: '40px' }}>
                   <Typography variant="h6" sx={{ color: 'black' }}>Love what you see?</Typography>
                   <Typography sx={{ color: 'black' }}>Drop us a message and we’ll get back to you in no time!</Typography>
                   <Button variant="contained" sx={{ backgroundColor: 'black', color: 'white', marginTop: '20px' }}>
                       Get started
                   </Button>
               </div>
           </Container>
    </div> 

    </>
  )
}

export default Pricing
