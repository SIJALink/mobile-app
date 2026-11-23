
"use client";

import { useState, useEffect } from "react";

export default function ProfilAdmin() {
  const [foto, setFoto] = useState<string>("");
  const [nama, setNama] = useState("Admin SIJALink");
  const [username, setUsername] = useState("admin");
  const [email, setEmail] = useState("admin@sijalink.test");
  const [telepon, setTelepon] = useState("081234567890");
  const [jabatan, setJabatan] = useState("Administrator");
  const [wilayah, setWilayah] = useState("Wilayah Operasional SIJALink");

  useEffect(() => {
    const fotoTersimpan = localStorage.getItem("foto_admin");
    const profilTersimpan = localStorage.getItem("profil_admin");

    if (fotoTersimpan) {
      setFoto(fotoTersimpan);
    }

    if (profilTersimpan) {
      try {
        const profil = JSON.parse(profilTersimpan);

        setNama(profil.nama || "Admin SIJALink");
        setUsername(profil.username || "admin");
        setEmail(profil.email || "admin@sijalink.test");
        setTelepon(profil.telepon || "081234567890");
        setJabatan(profil.jabatan || "Administrator");
        setWilayah(profil.wilayah || "Wilayah Operasional SIJALink");
      } catch {
        console.error("Data profil Admin tidak valid");
      }
    }
  }, []);

  function gantiFoto(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];

    if (!file) return;

    if (!file.type.startsWith("image/")) {
      alert("Pilih file gambar.");
      return;
    }

    if (file.size > 2 * 1024 * 1024) {
      alert("Ukuran foto maksimal 2 MB.");
      return;
    }

    const reader = new FileReader();

    reader.onload = () => {
      const hasil = reader.result as string;

      try {
        localStorage.setItem("foto_admin", hasil);
        setFoto(hasil);
      } catch {
        alert("Foto gagal disimpan. Coba gunakan gambar yang lebih kecil.");
      }
    };

    reader.readAsDataURL(file);
    e.target.value = "";
  }

  function simpanProfil(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();

    localStorage.setItem(
      "profil_admin",
      JSON.stringify({
        nama,
        username,
        email,
        telepon,
        jabatan,
        wilayah,
      })
    );

    alert("Profil Admin berhasil disimpan!");
  }

  function resetProfil() {
    setNama("Admin SIJALink");
    setUsername("admin");
    setEmail("admin@sijalink.test");
    setTelepon("081234567890");
    setJabatan("Administrator");
    setWilayah("Wilayah Operasional SIJALink");

    localStorage.removeItem("profil_admin");

    alert("Profil Admin berhasil dikembalikan ke data awal!");
  }

  return (
    <main className="min-h-screen bg-[#f2f7ff] p-4 text-[#102d60] sm:p-8">
      <div className="mx-auto max-w-5xl">

        {/* HEADER */}
        <div className="mb-6 rounded-2xl bg-[#082d68] p-6 text-white shadow-sm">
          <p className="text-sm text-blue-200">Pengaturan Akun</p>

          <h1 className="mt-2 text-2xl font-bold sm:text-3xl">
            Profil Admin
          </h1>

          <p className="mt-2 text-sm text-blue-100">
            Lihat dan kelola informasi profil Admin SIJALink.
          </p>
        </div>

        <div className="grid gap-6 lg:grid-cols-[280px_1fr]">

          {/* KARTU PROFIL */}
          <section className="rounded-2xl border border-blue-100 bg-white p-6 text-center shadow-sm">

            <img
              src={foto || "/default-profile.png"}
              alt="Foto Profil Admin"
              className="mx-auto h-28 w-28 rounded-full border-4 border-blue-100 object-cover"
            />

            <label className="mt-4 inline-block cursor-pointer rounded-xl bg-blue-600 px-5 py-2 text-sm font-semibold text-white hover:bg-blue-700">
              Ganti Foto

              <input
                type="file"
                accept="image/*"
                onChange={gantiFoto}
                className="hidden"
              />
            </label>

            <p className="mt-2 text-xs text-slate-400">
              Format gambar, maksimal 2 MB
            </p>

            <h2 className="mt-4 text-lg font-bold">
              {nama}
            </h2>

            <p className="mt-1 text-sm text-slate-500">
              {jabatan}
            </p>

            <div className="mt-5 rounded-xl bg-green-50 px-4 py-3">
              <p className="text-sm font-semibold text-green-700">
                ● Akun Aktif
              </p>
            </div>

            <div className="mt-5 border-t border-slate-100 pt-4 text-left">
              <p className="text-xs text-slate-500">
                Username
              </p>

              <p className="mt-1 font-semibold">
                {username}
              </p>
            </div>

            <div className="mt-4 border-t border-slate-100 pt-4 text-left">
              <p className="text-xs text-slate-500">
                Email
              </p>

              <p className="mt-1 break-all font-semibold">
                {email}
              </p>
            </div>
          </section>

          {/* FORM PROFIL */}
          <section className="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm sm:p-7">

            <h2 className="text-xl font-bold">
              Informasi Profil
            </h2>

            <p className="mt-1 text-sm text-slate-500">
              Perbarui informasi akun Admin.
            </p>

            <form
              onSubmit={simpanProfil}
              className="mt-6 space-y-5"
            >

              <div>
                <label className="mb-2 block text-sm font-semibold">
                  Nama Lengkap
                </label>

                <input
                  value={nama}
                  onChange={(e) => setNama(e.target.value)}
                  className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:border-blue-500"
                  required
                />
              </div>

              <div>
                <label className="mb-2 block text-sm font-semibold">
                  Username
                </label>

                <input
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:border-blue-500"
                  required
                />
              </div>

              <div>
                <label className="mb-2 block text-sm font-semibold">
                  Email
                </label>

                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:border-blue-500"
                  required
                />
              </div>

              <div>
                <label className="mb-2 block text-sm font-semibold">
                  Nomor Telepon
                </label>

                <input
                  value={telepon}
                  onChange={(e) => setTelepon(e.target.value)}
                  className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:border-blue-500"
                  required
                />
              </div>

              <div>
                <label className="mb-2 block text-sm font-semibold">
                  Jabatan
                </label>

                <input
                  value={jabatan}
                  readOnly
                  className="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 outline-none"
                />
              </div>

              <div>
                <label className="mb-2 block text-sm font-semibold">
                  Wilayah Kerja
                </label>

                <input
                  value={wilayah}
                  onChange={(e) => setWilayah(e.target.value)}
                  className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:border-blue-500"
                />
              </div>

              {/* TOMBOL */}
              <div className="flex flex-wrap gap-3 border-t border-slate-100 pt-5">

                <button
                  type="submit"
                  className="rounded-xl bg-[#0b3476] px-6 py-3 text-sm font-semibold text-white hover:bg-blue-800"
                >
                  Simpan Perubahan
                </button>

                <button
                  type="button"
                  onClick={resetProfil}
                  className="rounded-xl border border-slate-200 px-6 py-3 text-sm font-semibold text-slate-600 hover:bg-slate-50"
                >
                  Reset
                </button>

              </div>
            </form>
          </section>
        </div>

        <p className="mt-6 text-center text-xs text-slate-400">
          © 2026 SIJALink. All Rights Reserved.
        </p>

      </div>
    </main>
  );
}
