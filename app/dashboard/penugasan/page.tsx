
"use client";

import { useState } from "react";

type Tugas = {
  id: number;
  nama: string;
  pekerjaan: string;
  lokasi: string;
  tanggal: string;
  prioritas: string;
  status: string;
};

const dataAwal: Tugas[] = [
  {
    id: 1,
    nama: "Andi Saputra",
    pekerjaan: "Pemeriksaan jaringan pelanggan",
    lokasi: "Pasar Kemis, Tangerang",
    tanggal: "2026-11-23",
    prioritas: "Tinggi",
    status: "Menunggu",
  },
  {
    id: 2,
    nama: "Budi Santoso",
    pekerjaan: "Perbaikan gangguan jaringan",
    lokasi: "Rajeg, Tangerang",
    tanggal: "2026-11-23",
    prioritas: "Sedang",
    status: "Diproses",
  },
  {
    id: 3,
    nama: "Dedi Kurniawan",
    pekerjaan: "Pengecekan perangkat pelanggan",
    lokasi: "Sepatan, Tangerang",
    tanggal: "2026-11-24",
    prioritas: "Rendah",
    status: "Selesai",
  },
];

export default function PenugasanHarian() {
  const [data, setData] = useState<Tugas[]>(dataAwal);
  const [cari, setCari] = useState("");
  const [modal, setModal] = useState(false);
  const [editId, setEditId] = useState<number | null>(null);

  const formAwal = {
    nama: "",
    pekerjaan: "",
    lokasi: "",
    tanggal: "",
    prioritas: "Sedang",
    status: "Menunggu",
  };

  const [form, setForm] = useState(formAwal);

  function bukaTambah() {
    setEditId(null);
    setForm(formAwal);
    setModal(true);
  }

  function bukaEdit(tugas: Tugas) {
    setEditId(tugas.id);
    setForm({
      nama: tugas.nama,
      pekerjaan: tugas.pekerjaan,
      lokasi: tugas.lokasi,
      tanggal: tugas.tanggal,
      prioritas: tugas.prioritas,
      status: tugas.status,
    });
    setModal(true);
  }

  function simpanTugas() {
    if (
      !form.nama ||
      !form.pekerjaan ||
      !form.lokasi ||
      !form.tanggal
    ) {
      alert("Mohon lengkapi semua data penugasan!");
      return;
    }

    if (editId !== null) {
      setData((sebelumnya) =>
        sebelumnya.map((item) =>
          item.id === editId ? { ...item, ...form } : item
        )
      );
    } else {
      setData((sebelumnya) => [
        ...sebelumnya,
        { id: Date.now(), ...form },
      ]);
    }

    setModal(false);
    setForm(formAwal);
    setEditId(null);
  }

  function hapusTugas(id: number) {
    if (confirm("Apakah kamu yakin ingin menghapus penugasan ini?")) {
      setData((sebelumnya) =>
        sebelumnya.filter((item) => item.id !== id)
      );
    }
  }

  function ubahStatus(id: number, status: string) {
    setData((sebelumnya) =>
      sebelumnya.map((item) =>
        item.id === id ? { ...item, status } : item
      )
    );
  }

  const hasilCari = data.filter((item) =>
    `${item.nama} ${item.pekerjaan} ${item.lokasi}`
      .toLowerCase()
      .includes(cari.toLowerCase())
  );

  const jumlahMenunggu = data.filter(
    (item) => item.status === "Menunggu"
  ).length;

  const jumlahProses = data.filter(
    (item) => item.status === "Diproses"
  ).length;

  const jumlahSelesai = data.filter(
    (item) => item.status === "Selesai"
  ).length;

  return (
    <div className="min-h-screen bg-[#f2f7ff] p-4 text-[#102d60] sm:p-6 lg:p-8">

      {/* HEADER */}
      <div className="mb-7 flex flex-wrap items-center justify-between gap-4">
        <div>
          <p className="text-sm font-medium text-blue-600">
            SIJALink / Admin / Penugasan
          </p>
          <h1 className="mt-2 text-2xl font-bold sm:text-3xl">
            Penugasan Harian
          </h1>
          <p className="mt-2 text-sm text-slate-500">
            Kelola dan pantau tugas petugas lapangan SIJALink.
          </p>
        </div>

        <button
          onClick={bukaTambah}
          className="rounded-xl bg-blue-600 px-5 py-3 text-sm font-semibold text-white shadow-sm hover:bg-blue-700"
        >
          + Tambah Penugasan
        </button>
      </div>

      {/* STATISTIK */}
      <section className="mb-6 grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <div className="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm">
          <p className="text-sm text-slate-500">Total Penugasan</p>
          <h2 className="mt-2 text-3xl font-bold">{data.length}</h2>
          <p className="mt-2 text-xs text-blue-600">Seluruh tugas</p>
        </div>

        <div className="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm">
          <p className="text-sm text-slate-500">Menunggu</p>
          <h2 className="mt-2 text-3xl font-bold">{jumlahMenunggu}</h2>
          <p className="mt-2 text-xs text-amber-600">Belum dikerjakan</p>
        </div>

        <div className="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm">
          <p className="text-sm text-slate-500">Sedang Diproses</p>
          <h2 className="mt-2 text-3xl font-bold">{jumlahProses}</h2>
          <p className="mt-2 text-xs text-blue-600">Dalam pengerjaan</p>
        </div>

        <div className="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm">
          <p className="text-sm text-slate-500">Selesai</p>
          <h2 className="mt-2 text-3xl font-bold">{jumlahSelesai}</h2>
          <p className="mt-2 text-xs text-green-600">Tugas diselesaikan</p>
        </div>
      </section>

      {/* DAFTAR PENUGASAN */}
      <section className="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm sm:p-6">
        <div className="mb-5 flex flex-wrap items-center justify-between gap-4">
          <div>
            <h2 className="text-lg font-bold">Daftar Penugasan</h2>
            <p className="mt-1 text-sm text-slate-500">
              Daftar tugas yang diberikan kepada petugas.
            </p>
          </div>

          <input
            type="text"
            placeholder="Cari petugas atau tugas..."
            value={cari}
            onChange={(e) => setCari(e.target.value)}
            className="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm outline-none focus:border-blue-500 sm:w-72"
          />
        </div>

        <div className="overflow-x-auto">
          <table className="w-full min-w-[850px] text-left text-sm">
            <thead>
              <tr className="border-y border-slate-100 bg-slate-50 text-slate-500">
                <th className="px-4 py-4">Petugas</th>
                <th className="px-4 py-4">Pekerjaan</th>
                <th className="px-4 py-4">Lokasi</th>
                <th className="px-4 py-4">Tanggal</th>
                <th className="px-4 py-4">Prioritas</th>
                <th className="px-4 py-4">Status</th>
                <th className="px-4 py-4">Aksi</th>
              </tr>
            </thead>

            <tbody>
              {hasilCari.map((item) => (
                <tr
                  key={item.id}
                  className="border-b border-slate-100 hover:bg-blue-50/40"
                >
                  <td className="px-4 py-4 font-semibold">
                    {item.nama}
                  </td>

                  <td className="px-4 py-4">
                    {item.pekerjaan}
                  </td>

                  <td className="px-4 py-4">
                    {item.lokasi}
                  </td>

                  <td className="px-4 py-4">
                    {item.tanggal}
                  </td>

                  <td className="px-4 py-4">
                    <span
                      className={`rounded-full px-3 py-1 text-xs font-semibold ${
                        item.prioritas === "Tinggi"
                          ? "bg-red-100 text-red-700"
                          : item.prioritas === "Sedang"
                          ? "bg-amber-100 text-amber-700"
                          : "bg-green-100 text-green-700"
                      }`}
                    >
                      {item.prioritas}
                    </span>
                  </td>

                  <td className="px-4 py-4">
                    <select
                      value={item.status}
                      onChange={(e) =>
                        ubahStatus(item.id, e.target.value)
                      }
                      className="rounded-lg border border-slate-200 bg-white px-2 py-2 text-xs outline-none"
                    >
                      <option>Menunggu</option>
                      <option>Diproses</option>
                      <option>Selesai</option>
                    </select>
                  </td>

                  <td className="px-4 py-4">
                    <div className="flex gap-2">
                      <button
                        onClick={() => bukaEdit(item)}
                        className="rounded-lg bg-blue-100 px-3 py-2 text-xs font-semibold text-blue-700 hover:bg-blue-200"
                      >
                        Edit
                      </button>

                      <button
                        onClick={() => hapusTugas(item.id)}
                        className="rounded-lg bg-red-100 px-3 py-2 text-xs font-semibold text-red-700 hover:bg-red-200"
                      >
                        Hapus
                      </button>
                    </div>
                  </td>
                </tr>
              ))}

              {hasilCari.length === 0 && (
                <tr>
                  <td
                    colSpan={7}
                    className="px-4 py-10 text-center text-slate-400"
                  >
                    Belum ada penugasan yang ditemukan.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </section>

      {/* MODAL TAMBAH DAN EDIT */}
      {modal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="max-h-[90vh] w-full max-w-xl overflow-y-auto rounded-2xl bg-white p-6 shadow-xl">

            <h2 className="text-xl font-bold">
              {editId !== null ? "Edit Penugasan" : "Tambah Penugasan"}
            </h2>

            <p className="mt-1 text-sm text-slate-500">
              Lengkapi informasi tugas petugas lapangan.
            </p>

            <div className="mt-5 space-y-4">
              <div>
                <label className="text-sm font-medium">Nama Petugas</label>
                <input
                  type="text"
                  placeholder="Masukkan nama petugas"
                  value={form.nama}
                  onChange={(e) =>
                    setForm({ ...form, nama: e.target.value })
                  }
                  className="mt-2 w-full rounded-xl border border-slate-200 p-3 text-sm outline-none focus:border-blue-500"
                />
              </div>

              <div>
                <label className="text-sm font-medium">Jenis Pekerjaan</label>
                <input
                  type="text"
                  placeholder="Contoh: Pemeriksaan jaringan"
                  value={form.pekerjaan}
                  onChange={(e) =>
                    setForm({ ...form, pekerjaan: e.target.value })
                  }
                  className="mt-2 w-full rounded-xl border border-slate-200 p-3 text-sm outline-none focus:border-blue-500"
                />
              </div>

              <div>
                <label className="text-sm font-medium">Lokasi Tugas</label>
                <input
                  type="text"
                  placeholder="Masukkan lokasi tugas"
                  value={form.lokasi}
                  onChange={(e) =>
                    setForm({ ...form, lokasi: e.target.value })
                  }
                  className="mt-2 w-full rounded-xl border border-slate-200 p-3 text-sm outline-none focus:border-blue-500"
                />
              </div>

              <div>
                <label className="text-sm font-medium">Tanggal Tugas</label>
                <input
                  type="date"
                  value={form.tanggal}
                  onChange={(e) =>
                    setForm({ ...form, tanggal: e.target.value })
                  }
                  className="mt-2 w-full rounded-xl border border-slate-200 p-3 text-sm outline-none focus:border-blue-500"
                />
              </div>

              <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
                <div>
                  <label className="text-sm font-medium">Prioritas</label>
                  <select
                    value={form.prioritas}
                    onChange={(e) =>
                      setForm({ ...form, prioritas: e.target.value })
                    }
                    className="mt-2 w-full rounded-xl border border-slate-200 p-3 text-sm"
                  >
                    <option>Rendah</option>
                    <option>Sedang</option>
                    <option>Tinggi</option>
                  </select>
                </div>

                <div>
                  <label className="text-sm font-medium">Status</label>
                  <select
                    value={form.status}
                    onChange={(e) =>
                      setForm({ ...form, status: e.target.value })
                    }
                    className="mt-2 w-full rounded-xl border border-slate-200 p-3 text-sm"
                  >
                    <option>Menunggu</option>
                    <option>Diproses</option>
                    <option>Selesai</option>
                  </select>
                </div>
              </div>
            </div>

            <div className="mt-6 flex gap-3">
              <button
                onClick={() => setModal(false)}
                className="flex-1 rounded-xl border border-slate-200 py-3 text-sm font-semibold text-slate-600 hover:bg-slate-50"
              >
                Batal
              </button>

              <button
                onClick={simpanTugas}
                className="flex-1 rounded-xl bg-blue-600 py-3 text-sm font-semibold text-white hover:bg-blue-700"
              >
                Simpan Penugasan
              </button>
            </div>

          </div>
        </div>
      )}

      <footer className="mt-8 border-t border-blue-100 py-5 text-center text-xs text-slate-500">
        © 2026 SIJALink. All Rights Reserved.
      </footer>
    </div>
  );
}
